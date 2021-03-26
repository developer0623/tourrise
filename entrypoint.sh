#!/bin/sh
set -xe

rm -f /usr/src/app/tmp/pids/server.pid

bundle check || bundle install -j $(nproc)

exec "$@"
