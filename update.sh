#!/usr/bin/env bash
cd `dirname $0`

from=${1:-107}
to=${2:-109}

for y in `seq $from $to`; do
	for t in "1" "2" "X"; do
		(
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
			-d 'm_crsoutline=' \
			-d 'm_crsname= ' \
			> raw-name-$y-$t.json

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
			-d 'm_option=crsoutline' \
			-d 'm_crsoutline=' \
			-d 'm_crsname= ' \
			> raw-outline-$y-$t.json

			jq -s '.[0] * .[1]' raw-name-$y-$t.json raw-outline-$y-$t.json > pretty-$y-$t.json
			wc pretty-$y-$t.json
		) &
	done
done

echo "Waiting...."
wait
echo "Done."

find . -name "*-*-[12X].json" -size -10c -delete  # Empty
echo "Deleted empty file."

git add *.*  # No removed file
git commit -m "`date '+%b %d  %H:%M'`"
git push
