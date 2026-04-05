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

esphome_dir="$(cd "$(dirname "$0")/.." && pwd)"

if [ "$offsite" = true ]; then
    OP_ESPHOME_ITEM_NAME="ESPHome [Offsite]"
    output_dir="$esphome_dir/offsite"
else
    OP_ESPHOME_ITEM_NAME="ESPHome"
    output_dir="$esphome_dir"
fi

op item get --format json "$OP_ESPHOME_ITEM_NAME" | jq --raw-output '.fields[] | select(has("section")) | (.section.label | gsub("[\\s-]"; "_")) + "_" + (.label | gsub("[\\s-]"; "_")) + ": " + (.value | @sh)' | sort > "$output_dir/secrets.yaml"
