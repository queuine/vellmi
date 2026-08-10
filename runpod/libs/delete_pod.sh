#!/usr/bin/sh
script_path=$(realpath "$0")
script_dir="$(dirname "${script_path}")"

# service tokens necessary for the task
. "${script_dir}/export_rp_key.sh"

if [ $# -ne 1 ]; then
    echo "Usage: $0 <path_to_pod_id>";
    exit 1;
fi

# path to the pod id
pod_id_path="$1"
if [ ! -s "${pod_id_path}" ]; then
    echo "Error: Id path '${pod_id_path}' does not exist or is empty.";
    exit 1;
fi

python "${script_dir}/runpod/delete.py" "${pod_id_path}"

