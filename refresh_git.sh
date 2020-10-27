#!/bin/bash
BASEDIR=$(sh -c pwd)
for foldername in */; do \
  cd $foldername && \
  branch=$(git rev-parse --abbrev-ref HEAD) && \
  echo "======= Pulling $foldername --- branch: $branch  =======" && \
  git fetch && \
  git pull && \
  git remote prune origin 
  cd $BASEDIR
done
