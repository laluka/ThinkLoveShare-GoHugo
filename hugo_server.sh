#!/bin/bash

if [ ! -f "hugo" ]; then
    echo "Hugo found, cloning from docker! :)"
    ./copy_hugo_elf.sh
fi

clear
/bin/rm -rf resources
./hugo server --disableFastRender
