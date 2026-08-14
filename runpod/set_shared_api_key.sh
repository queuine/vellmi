#!/usr/bin/sh
#
# Makes shared vLLM API key and saves it.
# Run it as:
# ./set_shared_api_key.sh
#
script_path="$(realpath "$0")"
script_dir="$(dirname "${script_path}")"

if [ $# -ne 0 ]; then
    echo "Usage: $0";
    exit 1;
fi

pod_conf_name="$1"
pod_run_id="$2"

# path for the shared vLLM API key
shared_key_path="${script_dir}/keys/vllm_api_key"
if [ -s "${shared_key_path}" ]; then
    echo "Error: Shared vLLM API key file '${shared_key_path}' already exists and is not empty.";
    exit 1;
fi

touch "${shared_key_path}"
chmod go-rwx "${shared_key_path}"
"${script_dir}/../common/genkey/gen_vllm_api_key.sh" > "${shared_key_path}"

