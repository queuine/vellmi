#!/usr/bin/sh
script_path=$(realpath "$0")
script_dir="$(dirname "${script_path}")"

# service tokens necessary for the work
. "${script_dir}/export_rp_key.sh"
. "${script_dir}/export_hf_token.sh"

if [ $# -ne 4 ]; then
    echo "Usage: $0 <pod_name> <path_to_pod_conf> <path_to_pod_token> <path_for_pod_id>";
    exit 1;
fi

# name for the new pod
pod_name="$1"

# path to pod configuration
pod_conf_path="$2"
if [ ! -s "${pod_conf_path}" ]; then
    echo "Error: Config path '${pod_conf_path}' does not exist or is empty.";
    exit 1;
fi

# path to pod token
pod_key_path="$3"
if [ ! -s "${pod_key_path}" ]; then
    echo "Error: Token path '${pod_key_path}' does not exist or is empty.";
    exit 1;
fi

# path for saving the pod id
pod_id_path="$4"

export VLLM_API_KEY=$(cat "${pod_key_path}")

python "${script_dir}/runpod/make.py" "${pod_name}" "${pod_conf_path}" "${pod_id_path}"

