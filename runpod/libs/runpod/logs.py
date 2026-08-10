#!/usr/bin/env python
#
# Taking logs from a Runpod pod.
#

import os, sys

import requests

RP_API_KEY = os.getenv("RP_API_KEY", "").strip()

HEADERS = {
    "Authorization": f"Bearer {RP_API_KEY}",
}


def get_logs(headers, pod_id_path, tail_count):
    with open(pod_id_path, encoding="utf8") as pod_id_fh:
        pod_id = pod_id_fh.read().strip()
    log_url = (
        f"https://api.runpod.io/v2/pods/{pod_id}/logs?"
        f"tail={tail_count}"
    )
    s = requests.Session()
    with s.get(log_url, headers=headers, stream=True) as resp:
        for line in resp.iter_lines():
            if line:
                sys.stdout.write(str(line).rstrip() + "\n")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.stderr.write("\n".join([
            "This script has to be run as:",
            f"{sys.argv[0]} pod_id_path tail_count",
            "",
        ]))
        sys.exit()
    try:
        get_logs(HEADERS, sys.argv[1], sys.argv[2])
    except Exception as exc:
        sys.stderr.write("\n".join([
            "Cannot get logs.",
            str(exc),
            "",
        ]))
