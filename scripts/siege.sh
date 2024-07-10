#!/bin/bash
TARGET=$1
siege --verbose --time=2M --concurrent=100 $TARGET > siege.results