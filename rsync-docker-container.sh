#!/usr/bin/env bash

set -e

container=$1; shift
command=$*


docker exec -i $container bash -l -c "$command"
