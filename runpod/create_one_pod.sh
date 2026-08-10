#!/usr/bin/sh
#
# Makes a pod and saves its id.
# Run it e.g. as:
# ./create_one_pod.sh nemotron-3-nano-30b-a3b-nvfp4-kv-fp8 001
#
script_path="$(realpath "$0")"
script_dir="$(dirname "${script_path}")"

if [ $# -ne 2 ]; then
    echo "Usage: $0 <pod_conf_name> <pod_run_id>";
    exit 1;
fi

pod_conf_name="$1"
pod_run_id="$2"
pod_name="${pod_conf_name}/${pod_run_id}"

# path to pod configuration
pod_conf_path="${script_dir}/conf/${pod_conf_name}"

# dir for the pod's data
pod_dir="${script_dir}/pods/${pod_conf_name}/${pod_run_id}"
mkdir -p "${pod_dir}"

# path to pod api key
pod_key_path="${pod_dir}/pod.key"

# path for saving the pod id
pod_id_path="${pod_dir}/pod.id"
if [ -s "${pod_id_path}" ]; then
    echo "Error: Pod id file '${pod_id_path}' already exists and is not empty.";
    exit 1;
fi

"${script_dir}/libs/create_pod.sh" "${pod_name}" "${pod_conf_path}" "${pod_key_path}" "${pod_id_path}"

