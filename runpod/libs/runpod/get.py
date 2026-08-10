#!/usr/bin/env python
#
# Get info on a Runpod pod.
#

import os, sys, json

import requests

RP_API_KEY = os.getenv("RP_API_KEY", "").strip()

HEADERS = {
    "Authorization": f"Bearer {RP_API_KEY}",
}


def get_show_pod_info(headers, pod_id_path):
    with open(pod_id_path, encoding="utf8") as pod_id_fh:
        pod_id = pod_id_fh.read().strip()
    r = requests.get(
        f"https://api.runpod.io/v2/pods/{pod_id}",
        headers=headers,
    )
    sys.stdout.write(json.dumps(r.json(), indent=4) + "\n")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.stderr.write("\n".join([
            "This script has to be run as:",
            f"{sys.argv[0]} pod_id_path",
            "",
        ]))
        sys.exit()
    try:
        get_show_pod_info(HEADERS, sys.argv[1])
    except Exception as exc:
        sys.stderr.write("\n".join([
            "Could not get/show the pod info.",
            str(exc),
            "",
        ]))
