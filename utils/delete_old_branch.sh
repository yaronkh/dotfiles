#!/bin/bash

now=$(date +%s)
branch_for_delete=""
i=0
for b in $(git branch -r | grep -E 'yk/'); do
	t=$(git log --format="%at" -1 $b)
        time_passed_days=$(( (now - t) / 3600 / 24 ))
	if (( time_passed_days > 120 )); then
		bshort=$(basename $b)
		echo $bshort: $time_passed_days
		branch_for_delete="$branch_for_delete $bshort"
                i=$((i+1))
	fi
	if ((i >= 1)); then
		git push --delete yk $branch_for_delete
		i=0
                branch_for_delete=""
	fi
done
git push --delete yk $branch_for_delete
