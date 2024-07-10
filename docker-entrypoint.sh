#!/bin/bash

set -e

if [ "$#" -gt 0 ]; then
  echo "Executing: $@"
  exec "$@"
fi
