#!/bin/bash
#Target will be DNS name or IP address, e.g. https://google.com
TARGET=$1
siege --verbose --time=2M --concurrent=100 $TARGET > siege.results