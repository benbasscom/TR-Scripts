#!/bin/bash

repo_path="/path/to/your/munki_repo"


for file in `find "${repo_path}/pkgsinfo/"`
do

  fileName=`basename "${file}"`
  if [ "${fileName}" == ".DS_Store" ]
  then
    continue
  fi

  if [ -f "${file}" ]
  then
    plutil -lint "${file}" | grep -ve ": OK"
  fi
done