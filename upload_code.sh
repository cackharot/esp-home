#!/usr/bin/env bash

set +x

if ! command -v nodemcu-tool &> /dev/null
then
    echo "Mising nodemcu-tool binary! Try ./tools_install.sh first!"
    exit
fi

nodemcu-tool upload --port=/dev/cu.usbserial-1420 src/*.lua
