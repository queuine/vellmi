#!/usr/bin/env python
#
# Deletes a Runpod pod.
#

import os, sys, json

import requests

RP_API_KEY = os.getenv("RP_API_KEY", "").strip()

HEADERS = {
    "Authorization": f"Bearer {RP_API_KEY}",
}


def delete_pod(headers, pod_id_path):
    with open(pod_id_path, encoding="utf8") as pod_id_fh:
        pod_id = pod_id_fh.read().strip()
    r = requests.delete(
        f"https://api.runpod.io/v2/pods/{pod_id}",
        headers=headers,
    )
    try:
        sys.stdout.write(json.dumps(r.json(), indent=4) + "\n")
    except Exception:
        try:
            sys.stdout.write(str(r.text) + "\n")
        except Exception:
            pass


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.stderr.write("\n".join([
            "This script has to be run as:",
            f"{sys.argv[0]} pod_id_path",
            "",
        ]))
        sys.exit()
    try:
        delete_pod(HEADERS, sys.argv[1])
    except Exception as exc:
        sys.stderr.write("\n".join([
            "Could not delete the pod.",
            str(exc),
            "",
        ]))
