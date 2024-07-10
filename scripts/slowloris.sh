#!/bin/bash
#Target in format http://192.168.1.202/index.php
export TARGET=$1
slowhttptest -c 1000 -H -g -o slowhttp -i 10 -r 200 -t GET -u $TARGET-x 24 -p 3