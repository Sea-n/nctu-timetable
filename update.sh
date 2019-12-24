#!/usr/bin/env bash

for y in {107..108}; do
	for t in "1" "2" "X"; do
		curl -s 'https://timetable.nctu.edu.tw/?r=main/get_cos_list' \
		-d "m_acy=$y" \
		-d "m_sem=$t" \
		-d "m_acyend=$y" \
		-d "m_semend=$t" \
		-d 'm_degree=**' \
		-d 'm_dep_id=**' \
		-d 'm_group=**' \
		-d 'm_grade=**' \
		-d 'm_class=**' \
		-d 'm_option=crsname' \
		-d 'm_crsname= ' \
		-d 'm_teaname=**' \
		-d 'm_cos_id=**' \
		-d 'm_cos_code=**' \
		-d 'm_crstime=**' \
		-d 'm_crsoutline=**' \
		-d 'm_costype=**' > raw-$y-$t.json

		jq . raw-$y-$t.json > pretty-$y-$t.json
		wc pretty-$y-$t.json
	done
done

find . -size 3c -delete
