#!/usr/bin/env sh

OP_ESPHOME_ITEM_NAME="ESPHome"

esphome_dir="$(dirname $0)/.."

"$(dirname $0)/op_to_secrets_yaml.sh"

scp "$esphome_dir/secrets.yaml" homeassistant:config/esphome/