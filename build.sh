#!/bin/bash
set -e
set -x

BUILD="build"
COMMIT_SHA="$(git rev-parse --short HEAD)"
COMMIT_URL="https://github.com/dongheeJeong/www/commit/$(git rev-parse HEAD)"

rm -rf "${BUILD}"
mkdir -p "${BUILD}"
cp -r css "${BUILD}/"
cp -r img "${BUILD}/"


markdowns="$(find . -name "*.md" | sed -e 's|^\./||')"
for md in $markdowns; do

  dir="$(dirname "${md}")"
  mkdir -p "${BUILD}/${dir}"

  output="${BUILD}/$(echo "${md}" | cut -f1 -d'.').html"
  pandoc "${md}" -o "${output}" --variable "commit_url=${COMMIT_URL}" --variable "commit_sha=${COMMIT_SHA}" --template template.html

  echo "${md} -> ${output}"
done

