#!/usr/bin/sh
curr_path=$(realpath "$0")
curr_dir="$(dirname "${curr_path}")"

RP_API_KEY_PATH="${curr_dir}/../keys/rp_api_key"

if [ ! -s "${RP_API_KEY_PATH}" ]; then
    echo "Error: Runpod API key '${RP_API_KEY_PATH}' does not exist or is empty.";
    exit 1;
fi

export RP_API_KEY=$(cat "${RP_API_KEY_PATH}")

