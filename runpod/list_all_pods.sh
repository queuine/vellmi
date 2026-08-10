#!/usr/bin/sh
#
# Lists all current pods.
# Run it as:
# ./list_all_pods.sh
#
script_path="$(realpath "$0")"
script_dir="$(dirname "${script_path}")"

if [ $# -ne 0 ]; then
    echo "Usage: $0";
    exit 1;
fi

"${script_dir}/libs/list_pods.sh"

