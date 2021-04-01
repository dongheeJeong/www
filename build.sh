#!/bin/bash
set -e

BUILD="build"

rm -rf "${BUILD}"
mkdir -p "${BUILD}"
cp -r css "${BUILD}/"
cp -r img "${BUILD}/"

echo "<!DOCTYPE html> <html><h1>This page is for website health check !</h1></html>" > $BUILD/health.html


markdowns="$(find . -name "*.md" | sed -e 's|^\./||')"
for md in $markdowns; do

  dir="$(dirname "${md}")"
  mkdir -p "${BUILD}/${dir}"

  output="${BUILD}/$(echo "${md}" | cut -f1 -d'.').html"
  pandoc "${md}" -o "${output}" --template template.html 2> /dev/null

  echo "${md} -> ${output}"
done

