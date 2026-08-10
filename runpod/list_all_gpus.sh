#!/usr/bin/sh
#
# Lists all GPUs available for making pods.
# Run it as:
# ./list_all_gpus.sh
#
script_path="$(realpath "$0")"
script_dir="$(dirname "${script_path}")"

if [ $# -ne 0 ]; then
    echo "Usage: $0";
    exit 1;
fi

"${script_dir}/libs/list_gpus.sh"

