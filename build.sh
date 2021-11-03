#!/bin/bash
set -e

ROOT="$(pwd)"
BUILD="$ROOT/build"

rm -rf "${BUILD}"
mkdir -p "${BUILD}"
cp -r css "${BUILD}/"
cp -r img "${BUILD}/"



export COMMIT_SHA="$(git rev-parse --short HEAD)"
export COMMIT_URL="https://github.com/dongheeJeong/www/commit/$(git rev-parse HEAD)"

python3 build.py

