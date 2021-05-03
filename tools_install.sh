#!/usr/bin/env bash

set +x

echo "Installing dependencies"

if ! command -v npm &> /dev/null
then
    brew install nodejs
fi

if ! command -v esptool.py &> /dev/null
then
    pip3 install esptool
fi

if ! command -v nodemcu-tool &> /dev/null
then
    npm install nodemcu-tool -g
fi

esptool.py version
nodemcu-tool --version