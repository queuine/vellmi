#!/usr/bin/env python
#
# List GPUs available at Runpod.
#

import os, sys, json

import requests

RP_API_KEY = os.getenv("RP_API_KEY", "").strip()

HEADERS = {
    "Authorization": f"Bearer {RP_API_KEY}",
}


def list_gpus(headers):
    # Takes and writes the GPU list.
    r = requests.get(
        "https://api.runpod.io/v2/catalog/gpus",
        headers=headers,
    )
    sys.stdout.write(json.dumps(r.json(), indent=4) + "\n")


if __name__ == "__main__":
    if len(sys.argv) != 1:
        sys.stderr.write("\n".join([
            "This script has to be run as:",
            f"{sys.argv[0]}",
            "",
        ]))
        sys.exit(1)
    try:
        list_gpus(HEADERS)
    except Exception as exc:
        sys.stderr.write("\n".join([
            "Could not list the GPUs.",
            str(exc),
            "",
        ]))
        sys.exit(2)
