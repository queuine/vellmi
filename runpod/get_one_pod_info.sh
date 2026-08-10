#!/usr/bin/sh
#
# Takes pod's info and saves it.
# Run it e.g. as:
# ./get_one_pod_info.sh nemotron-3-nano-30b-a3b-nvfp4-kv-fp8 001
#
script_path="$(realpath "$0")"
script_dir="$(dirname "${script_path}")"

if [ $# -ne 2 ]; then
    echo "Usage: $0 <pod_conf_name> <pod_run_id>";
    exit 1;
fi

pod_conf_name="$1"
pod_run_id="$2"

# dir to the pod's data
pod_dir="${script_dir}/pods/${pod_conf_name}/${pod_run_id}"

# path to the pod id
pod_id_path="${pod_dir}/pod.id"

# path for saving the pod info
pod_info_path="${pod_dir}/pod.json"

"${script_dir}/libs/get_pod_info.sh" "${pod_id_path}" | tee "${pod_info_path}"

