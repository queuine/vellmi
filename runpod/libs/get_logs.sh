#!/usr/bin/sh
script_path=$(realpath "$0")
script_dir="$(dirname "${script_path}")"

# service tokens necessary for the task
. "${script_dir}/export_rp_key.sh"

if [ $# -ne 2 ]; then
    echo "Usage: $0 <path_to_pod_id> <log_tail_count>";
    exit 1;
fi

# path to the pod id
pod_id_path="$1"
if [ ! -s "${pod_id_path}" ]; then
    echo "Error: Id path '${pod_id_path}' does not exist or is empty.";
    exit 1;
fi

# the history size of logs to take too
tail_count="$2"

python "${script_dir}/runpod/logs.py" "${pod_id_path}" "${tail_count}"

