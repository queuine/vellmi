#!/usr/bin/sh
#
# Generates a key for vLLM.
#
script_path=$(realpath "$0")
script_dir="$(dirname "${script_path}")"

if [ $# -ne 0 ]; then
    echo "Usage: $0";
    exit 1;
fi

python "${script_dir}/gen_vllm_api_key.py"

