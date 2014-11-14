#!/bin/sh
while inotifywait -e close_write *.coffee; do ./compile.sh; done