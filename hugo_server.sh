#!/bin/bash

clear
/bin/rm -rf resources public
bash -c "sleep 1 && echo http://localhost:1313/" &
./hugo server --disableFastRender
