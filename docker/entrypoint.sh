#!/usr/bin/sh

# Start the nginx reverse proxy
service nginx start

export FORWARDED_ALLOW_IPS="${FORWARDED_ALLOW_IPS:-*}"
export UVICORN_FORWARDED_ALLOW_IPS="${FORWARDED_ALLOW_IPS}"
export UVICORN_PROXY_HEADERS=1

# Launch vLLM engine, bound locally on internal port 8001
exec vllm serve "$@" --host 127.0.0.1 --port 8001
