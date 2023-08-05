#!/usr/bin/env sh

# Usage: create_device <device_name> <device_package_name>
device_name=$1
device_package=$2

api_encryption_key=$(LC_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c 32 | base64)
fallback_ap_password=$(LC_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c 12)
ota_password=$(LC_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c 32)

cat >"$device_name.yaml" <<EOL
substitutions:
  device_name: "$device_name"
  api_encryption_key: "$api_encryption_key"
  fallback_ap_password: "$fallback_ap_password"
  ota_password: "$ota_password"
  wifi_password: !secret wifi_password
  wifi_ssid: !secret wifi_ssid

packages:
  remote_package:
    url: https://github.com/andyattebery/esphome-configs
    files:
      - packages/base.yaml
      - packages/$device_package.yaml
EOL
