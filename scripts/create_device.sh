#!/usr/bin/env sh

offsite=false

while [ $# -gt 0 ]; do
    case "$1" in
        --offsite)
            offsite=true
            shift
            ;;
        *)
            break
            ;;
    esac
done

if [ $# -ne 3 ]; then
    echo "Usage: create_device [--offsite] <device_name> <friendly_name> <device_template_name>"
    exit 1
fi

esphome_dir="$(cd "$(dirname "$0")/.." && pwd)"

if [ "$offsite" = true ]; then
    OP_ESPHOME_ITEM_NAME="ESPHome [Offsite]"
    output_dir="$esphome_dir/offsite"
else
    OP_ESPHOME_ITEM_NAME="ESPHome"
    output_dir="$esphome_dir"
fi

device_name=$1
friendly_name=$2
device_package=$3

api_encryption_key=$(LC_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c 32 | base64)
fallback_ap_password=$(LC_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c 12)
ota_password=$(LC_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c 32)

# Update 1Password
op_device_section_name=$(echo "$friendly_name" | tr '[:upper:]' '[:lower:]')
op_api_encryption_key_parameter="$op_device_section_name.api encryption key[password]=$api_encryption_key"
op_fallback_ap_password_parameter="$op_device_section_name.fallback ap password[password]=$fallback_ap_password"
op_ota_password_parameter="$op_device_section_name.ota password[password]=$ota_password"

${OP:-op} item edit "$OP_ESPHOME_ITEM_NAME" \
    "$op_api_encryption_key_parameter" \
    "$op_fallback_ap_password_parameter" \
    "$op_ota_password_parameter" \
    1>/dev/null

device_name_with_underscores=$(echo $device_name | sed 's/-/_/g')
secret_api_encryption_key="${device_name_with_underscores}_api_encryption_key"
secret_fallback_ap_password="${device_name_with_underscores}_fallback_ap_password"
secret_ota_password="${device_name_with_underscores}_ota_password"

# Create file
cat >"$output_dir/$device_name.yaml" <<EOL
substitutions:
  device_name: "$device_name"
  friendly_name: "$friendly_name"
  api_encryption_key: !secret $secret_api_encryption_key
  fallback_ap_password: !secret $secret_fallback_ap_password
  ota_password: !secret $secret_ota_password
  wifi_password: !secret wifi_password
  wifi_ssid: !secret wifi_ssid

packages:
  remote_package:
    url: https://github.com/andyattebery/esphome-config
    files:
      - templates/$device_package.yaml
EOL

if [ "$offsite" = true ]; then
    cat >>"$output_dir/$device_name.yaml" <<EOL
  base_offsite: !include packages/base-offsite.yaml
EOL
fi
