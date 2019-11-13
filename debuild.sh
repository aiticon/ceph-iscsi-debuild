#!/bin/bash -e

cd `dirname $0`
base_path="`pwd`/debuild"

./debianize.sh
apt-get update

cd ${base_path}
for conf_dir in *.debian-buildconf; do
  build_dir=$(echo ${conf_dir} |cut -d. -f1)
  cd ${base_path}/${build_dir}

  mk-build-deps -i -r -t 'apt-get -y --no-install-recommends'
  debuild -b -uc -us
done
