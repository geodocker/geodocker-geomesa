#! /usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
source /sbin/accumulo-lib.sh

# The first argument determines this container's role in the accumulo cluster
ROLE=${1:-}

if [ $ROLE = "master" ]; then
  POSTINIT="/sbin/register.sh" /sbin/entrypoint.sh "$@"
else
  /sbin/entrypoint.sh "$@"
fi
