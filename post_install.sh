#!/bin/bash

cd "$(dirname "$0")"

# chmod
chmod +x bin/*
find pack/ -name "*.sh" | xargs chmod +x
