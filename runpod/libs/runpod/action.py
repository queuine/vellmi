#!/usr/bin/env python
#
# Starts or stops a Runpod pod.
#

import os, sys, json

import requests

RP_API_KEY = os.getenv("RP_API_KEY", "").strip()

HEADERS = {
    "Authorization": f"Bearer {RP_API_KEY}",
    "Content-Type": "application/json",
}


def start_stop_pod(headers, pod_id_path, action):
    with open(pod_id_path, encoding="utf8") as pod_id_fh:
        pod_id = pod_id_fh.read().strip()
    if action not in ["start", "stop"]:
        raise ValueError(f"Unknown requested action: '{action}'")
    r = requests.post(
        f"https://api.runpod.io/v2/pods/{pod_id}/action",
        headers=headers,
        json={"action": action},
    )
    sys.stdout.write(json.dumps(r.json(), indent=4) + "\n")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.stderr.write("\n".join([
            "This script has to be run as:",
            f"{sys.argv[0]} pod_id_path start|stop",
            "",
        ]))
        sys.exit()
    try:
        start_stop_pod(HEADERS, sys.argv[1], sys.argv[2])
    except Exception as exc:
        sys.stderr.write("\n".join([
            f"Could not {sys.argv[1]} the pod.",
            str(exc),
            "",
        ]))
