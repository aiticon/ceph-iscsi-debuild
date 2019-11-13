FROM debian:buster

RUN apt-get update && apt-get install -y --no-install-recommends locales curl gnupg2

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen en_US.UTF-8
ENV LANG en_US.utf8

# Include the croit repo of ceph nautilus
RUN curl -ks https://mirror.croit.io/keys/release.asc |apt-key add -
RUN echo 'deb https://mirror.croit.io/debian-nautilus buster main' >> /etc/apt/sources.list.d/ceph_nautilus_coit.list

RUN apt-get install -y --no-install-recommends build-essential git
# devscripts contains mk-build-deps, which will pull the remaining dependencies from the control file for us.
RUN apt-get install -y --no-install-recommends devscripts equivs

RUN rm -rf /var/lib/apt/lists/*
