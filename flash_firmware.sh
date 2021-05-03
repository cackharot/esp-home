#!/usr/bin/env bash

esptool.py --port /dev/cu.usbserial-1420 write_flash -fm qio 0x00000 ./bin/nodemcu-release-13-modules-2021-05-03-14-53-14-float.bin
