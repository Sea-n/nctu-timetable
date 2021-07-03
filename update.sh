#!/usr/bin/env bash
cd `dirname $0`

from=${1:-109}
to=${2:-110}

for y in `seq $from $to`; do
	for t in "1" "2" "X"; do
		(
			curl -s 'https://timetable.nycu.edu.tw/?r=main/get_cos_list' \
			-d "m_acy=$y" \
			-d "m_sem=$t" \
			-d "m_acyend=$y" \
			-d "m_semend=$t" \
			-d 'm_dep_uid=**' \
			-d 'm_group=**' \
			-d 'm_grade=**' \
			-d 'm_class=**' \
			-d 'm_option=crsname' \
			-d 'm_teaname=**' \
			-d 'm_cos_id=**' \
			-d 'm_cos_code=**' \
			-d 'm_crstime=**' \
			-d 'm_costype=**' \
			-d 'm_crsoutline=**' \
			-d 'm_crsname= ' \
			> raw-name-$y-$t.json

			curl -s 'https://timetable.nycu.edu.tw/?r=main/get_cos_list' \
			-d "m_acy=$y" \
			-d "m_sem=$t" \
			-d "m_acyend=$y" \
			-d "m_semend=$t" \
			-d 'm_dep_uid=**' \
			-d 'm_group=**' \
			-d 'm_grade=**' \
			-d 'm_class=**' \
			-d 'm_option=crsoutline' \
			-d 'm_teaname=**' \
			-d 'm_cos_id=**' \
			-d 'm_cos_code=**' \
			-d 'm_crstime=**' \
			-d 'm_costype=**' \
			-d 'm_crsname=**' \
			-d 'm_crsoutline= ' \
			> raw-outline-$y-$t.json

			if [ `wc -c < raw-name-$y-$t.json` -gt 1234 ]; then
				if [ `wc -c < raw-outline-$y-$t.json` -gt 1234 ]; then
					jq -s '.[0] * .[1]' raw-name-$y-$t.json raw-outline-$y-$t.json > pretty-$y-$t.json
				else
					jq -s . raw-name-$y-$t.json > pretty-$y-$t.json
				fi
			else
				if [ `wc -c < raw-outline-$y-$t.json` -gt 1234 ]; then
					jq -s . raw-outline-$y-$t.json > pretty-$y-$t.json
				else
					echo "Failed: $y $t"
				fi
			fi
		)
	done
done

echo "Done."

find . -name "*-*-[12X].json" -size -10c -delete  # Empty
echo "Deleted empty file."

git add *.*  # No removed file
git commit -m "`date '+%b %d  %H:%M'`"
git push
