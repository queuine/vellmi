#!/usr/bin/env python
#
# Making a vLLM pod at Runpod.
#

import os, sys, json, tomllib

import requests

RP_API_KEY = os.getenv("RP_API_KEY", "").strip()
VLLM_API_KEY = os.getenv("VLLM_API_KEY", "").strip()
HF_TOKEN = os.getenv("HF_TOKEN", "").strip()

HEADERS = {
    "Authorization": f"Bearer {RP_API_KEY}",
    "Content-Type": "application/json",
}

DEFAULT_GPU_COUNT = 1
DEFAULT_DISK_SIZE = 20
DEFAULT_MOUNT_SIZE = 40
PORTS_EXPOSE = ["8000/http"]
MODELS_MOUNT = "/models"

POD_CONF = {
    "name": None,
    "image": None,
    "gpu": {
        "id": None,
        "count": DEFAULT_GPU_COUNT,
    },
    "disk": DEFAULT_DISK_SIZE,
    "mounts": {
        "persistent": {
            "size": DEFAULT_MOUNT_SIZE,
            "path": MODELS_MOUNT,
        },
    },
    "ports": PORTS_EXPOSE,
    "env": {
        "VLLM_API_KEY": VLLM_API_KEY,
        "HF_TOKEN": HF_TOKEN,
        "HF_HOME": MODELS_MOUNT,
    },
    "args": None,
}


def _get_vllm_args(path_to_conf, pod_conf):
    with open(path_to_conf, "rb") as fh:
        conf_raw = tomllib.load(fh)

        models = []
        params = []
        if ("vllm" not in conf_raw):
            raise ValueError("vllm not provided in config")
        if ("load" not in conf_raw["vllm"]):
            raise ValueError("vllm.load not provided in config")
        models.append(str(conf_raw["vllm"]["load"]))
        if "serve" in conf_raw["vllm"]:
            models.append(" ".join([
                "--served-model-name",
                str(conf_raw["vllm"]["serve"]),
            ]))
        if "spec" in conf_raw["vllm"]:
            models.append(" ".join([
                "--spec-model",
                str(conf_raw["vllm"]["spec"]),
            ]))
        if ("params" in conf_raw["vllm"]):
            params = [
                line.strip() for line in
                conf_raw["vllm"]["params"].splitlines()
                if line.strip() != ""
            ]
        pod_conf["args"] = " ".join(models + params)

        if ("env" in conf_raw):
            for var_key, var_value in (
                conf_raw["env"].items()
            ):
                pod_conf["env"][str(var_key)] = str(var_value)

        if ("boot" not in conf_raw):
            raise ValueError("boot not provided in config")
        if ("image" not in conf_raw["boot"]):
            raise ValueError("boot.image not provided in config")
        pod_conf["image"] = str(conf_raw["boot"]["image"])

        if ("gpu" not in conf_raw):
            raise ValueError("gpu not provided in config")
        if ("label" not in conf_raw["gpu"]):
            raise ValueError("gpu.label not provided in config")
        pod_conf["gpu"]["id"] = str(conf_raw["gpu"]["label"])
        if "count" in conf_raw["gpu"]:
            pod_conf["gpu"]["count"] = (
                int(conf_raw["gpu"]["count"])
            )

        if "storage" in conf_raw:
            if "system" in conf_raw["storage"]:
                pod_conf["disk"] = (
                    int(conf_raw["storage"]["system"])
                )
            if "models" in conf_raw["storage"]:
                pod_conf["mounts"]["persistent"]["size"] = (
                    int(conf_raw["storage"]["models"])
                )


def make_pod(
    headers,
    pod_conf,
    pod_name,
    pod_conf_path,
    pod_id_path,
):
    # Makes Runpod pod according to provided LLM specification,
    # and saves the pod id into the provided file path.
    pod_conf["name"] = pod_name
    try:
        _get_vllm_args(pod_conf_path, pod_conf)
    except Exception as exc:
        sys.stderr.write("\n".join([
            "Could not take vLLM args.",
            str(exc),
            "",
        ]))
        return

    try:
        r = requests.post(
            "https://api.runpod.io/v2/pods",
            headers=headers,
            json=pod_conf,
        )
        pod_info = r.json()
        pod_id = pod_info["id"]
    except Exception as exc:
        sys.stderr.write("\n".join([
            "Could not make the pod.",
            str(exc),
            "",
        ]))
        return

    try:
        with open(pod_id_path, "w", encoding="utf8") as pod_id_fh:
            pod_id_fh.write(str(pod_id))
    except Exception as exc:
        sys.stderr.write("\n".join([
            "Could not save the pod's id.",
            str(exc),
            "",
        ]))
        return

    try:
        sys.stdout.write(json.dumps(pod_info, indent=4) + "\n")
    except Exception as exc:
        sys.stderr.write("\n".join([
            "Could not show pod info.",
            str(exc),
            "",
        ]))
        try:
            print(r.text)
        except Exception:
            sys.stderr.write("\n".join([
                "Did not get pod info at all.",
                "",
            ]))


if __name__ == "__main__":
    if len(sys.argv) != 4:
        sys.stderr.write("\n".join([
            "This script has to be run as:",
            f"{sys.argv[0]} pod_name pod_conf_path pod_id_path",
            "",
        ]))
        sys.exit()
    make_pod(HEADERS, POD_CONF, sys.argv[1], sys.argv[2], sys.argv[3])
