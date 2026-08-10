#!/usr/bin/sh
#
# Makes pod's API key and saves it.
# Run it e.g. as:
# ./set_one_pod_api_key.sh nemotron-3-nano-30b-a3b-nvfp4-kv-fp8 001
#
script_path="$(realpath "$0")"
script_dir="$(dirname "${script_path}")"

if [ $# -ne 2 ]; then
    echo "Usage: $0 <pod_conf_name> <pod_run_id>";
    exit 1;
fi

pod_conf_name="$1"
pod_run_id="$2"

# dir for the pod's data
pod_dir="${script_dir}/pods/${pod_conf_name}/${pod_run_id}"
mkdir -p "${pod_dir}"

# path for saving the pod's vLLM API key
pod_api_key_path="${pod_dir}/pod.key"
if [ -s "${pod_api_key_path}" ]; then
    echo "Error: Pod API key file '${pod_api_key_path}' already exists and is not empty.";
    exit 1;
fi

touch "${pod_api_key_path}"
chmod go-rwx "${pod_api_key_path}"
"${script_dir}/../common/genkey/gen_vllm_api_key.sh" > "${pod_api_key_path}"

