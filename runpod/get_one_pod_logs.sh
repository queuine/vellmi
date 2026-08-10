#!/usr/bin/sh
#
# Takes pod's logs and saves them.
# Run it e.g. as:
# ./get_one_pod_logs.sh nemotron-3-nano-30b-a3b-nvfp4-kv-fp8 001 1000
#
script_path="$(realpath "$0")"
script_dir="$(dirname "${script_path}")"

if [ $# -ne 3 ]; then
    echo "Usage: $0 <pod_conf_name> <pod_run_id> <with_count_of_past_logs>";
    exit 1;
fi

pod_conf_name="$1"
pod_run_id="$2"

# dir to the pod's data
pod_dir="${script_dir}/pods/${pod_conf_name}/${pod_run_id}"

# path to the pod id
pod_id_path="${pod_dir}/pod.id"

# path for saving the pod logs
pod_log_path="${pod_dir}/pod.log"

# count of past logs to take too
pod_log_tail="$3"

"${script_dir}/libs/get_logs.sh" "${pod_id_path}" "${pod_log_tail}" | tee -a "${pod_log_path}"

