#!/bin/bash
BASEDIR=$(sh -c pwd)

for foldername in */; do \
  cd $foldername && \
  branch=$(git rev-parse --abbrev-ref HEAD) && \
  lbranches=$(git branch -a)
  echo "======= Status for $foldername --- branch: $branch  =======" && \
  git status
  echo "------- local branches  --------" && \
  echo "$lbranches"
  echo ""
  cd $BASEDIR
done
