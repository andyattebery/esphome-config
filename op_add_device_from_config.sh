#!/usr/bin/env sh

OP_ESPHOME_ITEM_NAME="ESPHome"

file=$1

# Get values from file
device_name=$(yq '.substitutions.device_name' $file)
friendly_name=$(yq '.substitutions.friendly_name' $file)
fallback_ap_password=$(yq '.substitutions.fallback_ap_password' $file)
ota_password=$(yq '.substitutions.ota_password' $file)

if [ "${fallback_ap_password#*"fallback_ap"}" != "$fallback_ap_password" ] && [ "${ota_password#*"ota_password"}" != "$ota_password" ]; then
    echo "fallback_ap_password and ota_password are already secrets"
    exit 0
fi

op_device_section_name=$(echo "$friendly_name" | tr '[:upper:]' '[:lower:]')

echo $op_device_section_name
echo $fallback_ap_password
echo $ota_password

# Update 1Password
op_fallback_ap_password_parameter="$op_device_section_name.fallback ap password[password]=$fallback_ap_password"
op_ota_password_parameter="$op_device_section_name.ota password[password]=$ota_password"

op item edit "$OP_ESPHOME_ITEM_NAME" \
    "$op_fallback_ap_password_parameter" \
    "$op_ota_password_parameter" \
    1>/dev/null

# Update file with secrets
device_name_with_underscores=$(echo $device_name | sed 's/-/_/g')
# echo $device_name_with_underscores
secret_fallback_ap_password="!secret ${device_name_with_underscores}_fallback_ap_password"
secret_ota_password="!secret ${device_name_with_underscores}_ota_password"

sed -i '' "s/fallback_ap_password:.*$/fallback_ap_password: $secret_fallback_ap_password/" $file
sed -i '' "s/ota_password:.*$/ota_password: $secret_ota_password/" $file
