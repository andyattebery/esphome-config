#!/usr/bin/env sh

OP_ESPHOME_ITEM_NAME="ESPHome"

op item get --format json "$OP_ESPHOME_ITEM_NAME" | jq --raw-output '.fields[] | select(has("section")) | (.section.label | gsub("[\\s-]"; "_")) + "_" + (.label | gsub("[\\s-]"; "_")) + ": " + (.value | @sh)' | sort > esphome/secrets.yaml
