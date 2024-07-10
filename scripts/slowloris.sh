#!/bin/bash
TARGET=$1
slowhttptest -c 1000 -H -g -o slowhttp -i 10 -r 200 -t GET -u $TARGET-x 24 -p 3