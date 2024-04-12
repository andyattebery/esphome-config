#!/usr/bin/env sh

esphome_dir="$(dirname $0)/.."

scp "$esphome_dir/secrets.yaml" homeassistant:config/esphome/