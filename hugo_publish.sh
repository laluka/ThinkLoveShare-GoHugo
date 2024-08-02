#!/bin/bash

if [ ! -f "hugo" ]; then
    echo "Hugo found, cloning from docker! :)"
    ./copy_hugo_elf.sh
fi

clear
if [ $# -ne 1 ]; then
    echo "Please specify commit message"
    exit
fi

# Show what we'll do
git status
read -p "Add all and publish as : $1 ?"

# Clean the published dir
if [ -d "ThinkLoveShare.github.io/.git" ]; then
	/bin/rm -rf ThinkLoveShare.github.io/* # Keeps the .git
else
	git clone git@github.com:ThinkLoveShare/ThinkLoveShare.github.io.git
	/bin/rm -rf ThinkLoveShare.github.io/* # Keeps the .git
fi

pushd ThinkLoveShare.github.io
git reset --hard
git pull
popd

# Generate static files
./hugo -d ThinkLoveShare.github.io/ -b https://thinkloveshare.com/
git add .
git status
read -p "Still sure ?"
git commit -a -m "$1"
git push

# Publish the site
pushd ThinkLoveShare.github.io/
git add .
git commit -a -m "$1"
git push
popd
