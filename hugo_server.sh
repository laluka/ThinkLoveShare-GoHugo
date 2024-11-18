#!/bin/bash

clear
/bin/rm -rf ./resources /tmp/hugo_cache
./hugo server --noHTTPCache --noTimes --ignoreCache --disableFastRender -b http://127.0.0.1/
