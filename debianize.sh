#!/bin/bash -e

cd "`dirname $0`/debuild"

for conf_dir in *.debian-buildconf; do
  build_dir=$(echo ${conf_dir} |cut -d. -f1)
  cp -RTv ${conf_dir}/ ${build_dir}/debian
done

