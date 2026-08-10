#!/usr/bin/sh
script_path=$(realpath "$0")
script_dir="$(dirname "${script_path}")"

# service tokens necessary for the task
. "${script_dir}/export_rp_key.sh"

if [ $# -ne 0 ]; then
    echo "Usage: $0";
    exit 1;
fi

python "${script_dir}/runpod/gpus.py"

