#!/usr/bin/env bash

set -x

PREFIX="homeassistant"

mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t "$PREFIX/sensor/2703814/volt/config" \
  -m '{"~": "homeassistant/sensor/2703814/volt", "device_class": "voltage", "name": "AC Voltage", "stat_t": "~/state", "val_tpl": "{{value_json.volts}}"}'

mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t "$PREFIX/sensor/2703814/office_temp/config" \
  -m '{"~": "homeassistant/sensor/2703814/temp_and_hum", "device_class": "temperature", "name": "Office Temperature", "stat_t": "~/state", "val_tpl": "{{value_json.temperature}}"}'

mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t "$PREFIX/sensor/2703814/office_humidity/config" \
  -m '{"~": "homeassistant/sensor/2703814/temp_and_hum", "device_class": "humidity", "name": "Office Humidity", "stat_t": "~/state", "val_tpl": "{{value_json.humidity}}"}'
