==============================
Debian packages for ceph-iscsi
==============================

Official `ceph-iscsi <https://docs.ceph.com/docs/master/rbd/iscsi-overview/>`_ packages currently only exist for RedHat distributions.
For Debian the documentation describes how to install manually from source: https://docs.ceph.com/docs/master/rbd/iscsi-target-cli-manual-install/

This GIT repository includes the necessary sources as submodules and provides buildrules that follow the *manual installation* document mentioned above.

Abstract
--------

* Clone recursive with `ceph-iscsi` source repositories in submodules::

    git clone --recursive https://github.com/aiticon/ceph-iscsi-debuild.git
    cd ceph-iscsi-debuild

* Pick a Debian version (`buster` or `stretch` branch) and copy the buildrules (`debian` directory)::

    export deb_target=buster (or stretch)
    git checkout deb_targets/${deb_target}
    ./debianize.sh

* There is a `Dockerfile` that prepares a build-environment based on `debian:buster` or `debian:stretch` images from Docker hub (500-600MB diskspace). Run once::

    docker build -t iscsi-buildenv:${deb_target} .

* Mount the source directories into a new container and build::

    docker run --rm --mount src="$(pwd)",target=/usr/src/ceph-iscsi,type=bind iscsi-buildenv:${deb_target} /usr/src/ceph-iscsi/debuild.sh

If all goes well, the `.deb` files will be in the `debuild` directory.
If not, try to build manually::

    docker run -it --mount src="$(pwd)",target=/usr/src/ceph-iscsi,type=bind iscsi-buildenv:${deb_target} /bin/bash
    root@4711:/# cd /usr/src/ceph-iscsi
    root@4711:/usr/src/ceph-iscsi# ./debuild.sh (..debugging as needed)

Compiling for a different Ceph version
--------------------------------------
By default the build containers will include the following Croit Repos to be able to link `tcmu-runner` against an up to date ceph version:

======= ================ =======================================
Debian   Ceph Version    Packages from
======= ================ =======================================
Buster   Nautilus (14.2) https://mirror.croit.io/debian-nautilus
Stretch  Mimic (13.2)    https://mirror.croit.io/debian-mimic
======= ================ =======================================

Alternative builds could be

======= =============== =======================================================
Debian  Ceph Version    Packages from
======= =============== =======================================================
Buster  Luminous (12.2) Buster Main
Stretch Luminous (12.2) https://download.ceph.com/debian-luminous/dists/stretch
Stretch Luminous (12.2) Stretch Backports
Stretch Jewel (10.2)    Stretch Main
======= =============== =======================================================

To build any of these the Dockerfile must be changed to include the correct `/etc/apt/sources.list.d` entries.
In addition the corresponding version has to be set in the dependency statements of the Debian control files:

- At "`Depends:`" in `debuild/ceph-iscsi.debian-buildconf/control`::

    python-rados (>= 1X.2)
    python-rbd (>= 1X.2)

- At "`Build-Depends:`" in `debuild/tcmu-runner.debian-buildconf/control`::

    librbd-dev (>= 1X.2)
    librados-dev (>= 1X.2)
