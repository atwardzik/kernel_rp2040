#!/bin/bash

set -e

mkdir -p build

cmake -S . -B build -G "Unix Makefiles" "$@"
