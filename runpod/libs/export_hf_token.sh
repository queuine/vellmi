#!/usr/bin/sh
curr_path=$(realpath "$0")
curr_dir="$(dirname "${curr_path}")"

HF_TOKEN_PATH="${curr_dir}/../keys/hf_token"

if [ ! -s "${HF_TOKEN_PATH}" ]; then
    echo "Error: Hugging Face token '${HF_TOKEN_PATH}' does not exist or is empty.";
    exit 1;
fi

export HF_TOKEN=$(cat "${HF_TOKEN_PATH}")

