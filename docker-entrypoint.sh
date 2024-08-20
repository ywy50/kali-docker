#!/bin/bash

set -e

# Start supervisord in the background
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf &

if [ "$#" -gt 0 ]; then
  echo "Executing: $@"
  exec "$@"
fi
