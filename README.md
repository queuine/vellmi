# vellmi: management of vLLM pods in GPU clouds

Vellmi provides making and managing vLLM pods on Runpod GPU clouds.
It is based on two components:

- [vellmi-pod](https://hub.docker.com/r/queuine/vellmi-pod) Docker image with vLLM
  and nginx-based reverse proxy for making available the vLLM API paths
  that are secured by vLLM API keys, along with safe metrics,
- a set of scripts that make and manage secure pods that boot the vellmi-pod Docker image
  with specifications of the pod environment and of the models that vLLM has to run.

### Structure of the *vellmi* system

The pod-management scripts are at the `runpod` directory of the repository,
with configuration files for specifications of pod types expected in the `runpod/conf` directory.
Several such configuration files are prepared there.
Information on individual pods is at the `runpod/pods` directory.

Vellmi has been developed primarily as a tool for evaluating usability of various LLMs
for the [arxifter](https://arxifter.quadet.com/) system.
The LLMs that have been tested this way are *Nemotron-3-Nano-30B-A3B* and *Laguna-XS-2.1*,
see the `runpod/conf/arxifter` directory .

### Use of the *vellmi* system

To use the *vellmi* system, tokens for Hugging Face and for Runpod have to be set
in the `runpod/keys` directory.

To get a secure pod running along with taking the pod info and its logs, use the `run_one_pod.sh` script.
To run e.g. a Nemotron-3-Nano-30B-A3B pod with its specification set at the
*rupnpod/conf/nemotron-3-nano-30b-a3b-nvfp4-kv-fp8.toml* file, run:

- `./runpod/run_one_pod.sh nemotron-3-nano-30b-a3b-nvfp4-kv-fp8 001`

where the `001` parameter (of any textual content) is for distinguishing individual pods
with the used configuration.

The pod can be stopped (if running), started (if being stopped), removed by the respective
scripts in the *runpod* directory. Regarding the example pod made above, it goes as:

- `./runpod/stop_one_pod.sh nemotron-3-nano-30b-a3b-nvfp4-kv-fp8 001`
- `./runpod/start_one_pod.sh nemotron-3-nano-30b-a3b-nvfp4-kv-fp8 001`
- `./runpod/delete_one_pod.sh nemotron-3-nano-30b-a3b-nvfp4-kv-fp8 001`

Notice that individual GPU types have a volatile availability at Runpod, and thus making a pod
fails if the asked-for GPU is not available on Runpod clouds at the time of making the pod.
