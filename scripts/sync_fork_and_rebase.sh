#!/bin/bash

# Codes taken from here:
# https://www.cyberciti.biz/faq/linux-bash-exit-status-set-exit-statusin-bash/
ERR_BAD_DIR=20

patch_branch="patch/custom"
echo "Assuming patch branch is $patch_branch"

repo_dir=$1
if [ -z "$repo_dir" ]; then
  repo_dir=$(pwd)
  echo "Using current directory, \"$repo_dir\" as repo directory"
fi
if [ ! -d "$repo_dir" ]; then
  echo "Directory $repo_dir does not exist"
  exit $ERR_BAD_DIR
fi

echo "Saving current directory"
current_dir=$(pwd)

cd "$repo_dir" || exit 1

# Check if the current directory is a git repo
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "Directory $repo_dir is not a git repository"
  exit $ERR_BAD_DIR
fi

# Make sure git are installed
if ! command -v git &>/dev/null; then
  echo "git could not be found"
  exit 1
fi

# Check if we are switched to patch branch
current_branch=$(git branch --show-current)
echo "Current branch: $current_branch"
if [[ "$current_branch" != "$patch_branch" ]]; then
  echo "You are not on $patch_branch branch"
  exit 1
fi

# Check if remote upstream is set
if ! git remote -v | grep -q "upstream"; then
  echo "Upstream remote is not set"
  echo "Please run the following command to set upstream remote"
  echo "git remote add upstream <upstream_repo_url>"
  exit 1
fi

# Check if there no changes in the local branch
if ! git diff --quiet; then
  echo "There are changes in the current branch"
  echo "Please stash or commit the changes"
  exit 1
fi

# Then, sync fork with original repo
git fetch upstream
git checkout main
git merge upstream/main
echo "Done syncing fork with original repo"

# Switch to patch branch
git checkout $patch_branch

# Rebase patch branch with main branch
git rebase main

cd "$current_dir" || exit 1
echo "Done"
