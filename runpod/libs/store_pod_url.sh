#!/usr/bin/sh

if [ $# -ne 2 ]; then
    echo "Usage: $0 <path_to_pod_id> <path_for_pod_url>";
    exit 1;
fi

# path to the pod id
pod_id_path="$1"
if [ ! -s "${pod_id_path}" ]; then
    echo "Error: Id path '${pod_id_path}' does not exist or is empty.";
    exit 1;
fi

# path for saving the pod URL
pod_url_path="$2"

pod_id=$(cat "$pod_id_path")
pod_url="https://${pod_id}-8000.proxy.runpod.net/v1"

printf "%s" "${pod_url}" > "${pod_url_path}"

