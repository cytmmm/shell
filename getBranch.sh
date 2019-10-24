#!/bin/bash

project_name=$1
project_dir=$2
pushd $1
if [[ $? != 0 ]]; then
    exit 1
fi
git clean -xdfq && git reset -q --hard && git remote update && git checkout -q master && git remote prune origin && git pull -q --all && git branch -a  | grep -v \*  | awk 'NR!=1{print}' | awk -F 'remotes/origin/' '{print $2 }'
popd