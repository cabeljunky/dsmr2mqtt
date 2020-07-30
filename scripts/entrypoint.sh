#!/bin/sh

set -e

/usr/bin/dsmr2mqtt -d $DSMR_SERIAL -m $DSMR_MQTT_URL -p $DSMR_MQTT_PORT