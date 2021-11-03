#!/bin/bash
set -e

ROOT="$(pwd)"
BUILD="$ROOT/build"

rm -rf "${BUILD}"
mkdir -p "${BUILD}"
cp -r css "${BUILD}/"
cp -r img "${BUILD}/"


tmpl="$ROOT/template"
category_index_tmpl="$tmpl/category_index.tmpl.html"
article_tmpl="$tmpl/general_article.tmpl.html"
metadata_tmpl="$tmpl/metadata.pandoc-tpl"


COMMIT_SHA="$(git rev-parse --short HEAD)"
COMMIT_URL="https://github.com/dongheeJeong/www/commit/$(git rev-parse HEAD)"



# 루트 index.html 생성
pandoc index.md \
	-f markdown \
	-o "$BUILD/index.html" \
	--variable "commit_url=${COMMIT_URL}" \
	--variable "commit_sha=${COMMIT_SHA}" \
	--template $article_tmpl


cd article
categories="$(find . -d 1 -type d)"

for category in $categories; do
	category="$(basename $category)"
	category_output="${BUILD}/$category"
	mkdir -p "$category_output"

	metadata="$(mktemp /tmp/www-build.metadata.XXXXX)"
	echo "[]" > $metadata

	for md in $(find $category -type f -name "*.md"); do

		# 각 markdown metadata를 $metadata로 통합
		title="$(pandoc --template=$metadata_tmpl $md | jq -r .title)"
		date="$(pandoc --template=$metadata_tmpl $md | jq -r .date)"
		html_file="$(basename $md | cut -f1 -d'.').html"
		cat $metadata | jq ". + [{\"title\": \"$title\", \"date\": \"$date\", \"html_file\": \"$html_file\"}]" | tee $metadata

		# article markdown -> html
		pandoc $md \
			-f markdown \
			-o "$category_output/$html_file" \
			--variable "commit_url=${COMMIT_URL}" \
			--variable "commit_sha=${COMMIT_SHA}" \
			--variable "category=${category}" \
			--template $article_tmpl
	done

	# metadata를 date 내림차순 정렬, yaml 형식으로 변경
	# --metadata-file 옵션에서 yaml 형식만 받는 것 같다.
	cat $metadata | jq 'sort_by(.date)|reverse' | jq '{"articles": .}' | yq eval -P - | tee $metadata

	# category 디렉토리의 index.html 생성
	# markdown을 변환하는게 아니므로 dummy 파일을 생성한다.
	dummy_md="$(mktemp /tmp/www-build.md.XXXXX)"
	pandoc $dummy_md \
		-f markdown \
		-o "${category_output}/index.html" \
		--variable "commit_url=${COMMIT_URL}" \
		--variable "commit_sha=${COMMIT_SHA}" \
		--variable "category=${category}" \
		--metadata-file "$metadata" \
		--template $category_index_tmpl

	rm "$metadata"
	rm "$dummy_md"
done
