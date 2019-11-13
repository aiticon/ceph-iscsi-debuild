#!/bin/bash -e

cd "`dirname $0`/debuild"
base_path=`pwd`

find . -depth -type d -name .pybuild -exec rm -rf {} \;

for conf_dir in *.debian-buildconf; do
  pkg_name=$(echo ${conf_dir} |cut -d. -f1)
  egg_name=$(echo ${pkg_name} |tr '-' '_')

  cd ${base_path}/${pkg_name}
  [ -d debian ] && rm -rf debian
  [ -d ${egg_name}.egg-info ] && rm -rf ${egg_name}.egg-info

  cd ${base_path}
  rm -f *${pkg_name}*.deb ${pkg_name}*.build ${pkg_name}*.buildinfo ${pkg_name}*.changes
done
