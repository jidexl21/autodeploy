#!/bin/bash

source  "./autodeploy.cfg"
appfolder=$FOLDER
repo=$REPO
branch=$BRANCH

source "utils/check.sh"
rm -rf $appfolder
git clone $repo --branch $branch --single-branch
