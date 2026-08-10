#!/usr/bin/sh
#
# Saves the URL under which the pod's vLLM is avaliable.
# Run it e.g. as:
# ./store_one_pod_url.sh nemotron-3-nano-30b-a3b-nvfp4-kv-fp8 001
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

# path for saving the pod URL
pod_url_path="${pod_dir}/pod.url"
if [ -s "${pod_url_path}" ]; then
    echo "Error: Pod URL file '${pod_url_path}' already exists and is not empty.";
    exit 1;
fi

"${script_dir}/libs/store_pod_url.sh" "${pod_id_path}" "${pod_url_path}"

