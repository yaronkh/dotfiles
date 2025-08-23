#!/bin/bash

# Function to print script usage
usage() {
    echo "Usage: $0 <src_branch> <dst_branch>"
    exit 1
}

# Ensure the script is called with two parameters
if [ "$#" -ne 2 ]; then
    usage
fi

src_branch=$1
dst_branch=$2

# Find the common ancestor of the two branches
common_ancestor=$(git merge-base "$src_branch" "$dst_branch")
if [ -z "$common_ancestor" ]; then
    echo "Error: Could not find common ancestor of $src_branch and $dst_branch"
    exit 1
fi

# Print table header
printf "%-12s %-20s %-40s %s\n" "commit_short" "author" "header" "reason"
printf "%-12s %-20s %-40s %s\n" "------------" "------" "------" "------"

# Iterate through the commits in the src_branch starting from the common ancestor
src_commits=$(git rev-list "$common_ancestor".."$src_branch")

for commit in $src_commits; do
    commit_short=$(echo "$commit" | cut -c 1-10)
    commit_msg=$(git log -1 --format=%B "$commit")
    commit_header=$(git log -1 --pretty=format:%s "$commit" | cut -c 1-40)
    author=$(git log -1 --pretty=format:%an "$commit")
    change_id=$(echo "$commit_msg" | grep -oP '(?<=Change-Id: )[^\s]+')

    if [ -z "$change_id" ]; then
        printf "%-12s %-20s %-40s %s\n" "$commit_short" "$author" "$commit_header" "-->does not have Change-Id field"
    else
        # Check if the Change-Id exists in the destination branch
        dst_commit=$(git log "$dst_branch" --grep="Change-Id: $change_id" -1 --pretty=format:%H)
        if [ -z "$dst_commit" ]; then
            printf "%-12s %-20s %-40s %s\n" "$commit_short" "$author" "$commit_header" " -->is not present in dst branch"
        fi
    fi
done

