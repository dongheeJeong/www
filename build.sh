#!/bin/bash
set -e
#set -x

ROOT="build"
TEMPLATE="template.html.j2"


echo "Delete ${ROOT}/ and re-generate everything"
rm -rf ${ROOT}
mkdir -p ${ROOT}


echo "Copy css/ in ${ROOT}/"
cp -r css ${ROOT}/css


echo "Copy mics/ in ${ROOT}/"
cp misc/* ${ROOT}/


echo ""
echo "Start Template all from data/ to ${ROOT}/"
for DATA in data/*; do
  fname="$(echo ${DATA} | cut -d'/' -f2 | cut -d'.' -f1)"
  path="${ROOT}/$(cat ${DATA} | yq -r .path)"

  mkdir -p ${path}
  cp -r css "${path}/css"

  jinja -d ${DATA} ${TEMPLATE} -o ${path}/${fname}.html 1>&2 2>/dev/null
  echo "Template done ${fname}.html at ${path}"
done

