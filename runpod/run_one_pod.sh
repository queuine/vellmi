#!/usr/bin/sh
#
# Makes a pod, saves its info and takes its logs.
# Run it e.g. as:
# ./run_one_pod.sh nemotron-3-nano-30b-a3b-nvfp4-kv-fp8 001
#
script_path="$(realpath "$0")"
script_dir="$(dirname "${script_path}")"

if [ $# -ne 2 ]; then
    echo "Usage: $0 <pod_conf_name> <pod_run_id>";
    exit 1;
fi

pod_conf_name="$1"
pod_run_id="$2"

# count of past logs to take too
pod_log_tail=1000

set -e

"${script_dir}/set_one_pod_api_key.sh" "${pod_conf_name}" "${pod_run_id}"
"${script_dir}/create_one_pod.sh" "${pod_conf_name}" "${pod_run_id}"
"${script_dir}/store_one_pod_url.sh" "${pod_conf_name}" "${pod_run_id}"
"${script_dir}/get_one_pod_info.sh" "${pod_conf_name}" "${pod_run_id}"
"${script_dir}/get_one_pod_logs.sh" "${pod_conf_name}" "${pod_run_id}" "${pod_log_tail}"

