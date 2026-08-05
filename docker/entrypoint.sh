#!/usr/bin/sh

# Start the nginx reverse proxy
service nginx start

# Launch vLLM engine, bound locally on internal port 8001
exec vllm serve "$VLLM_MODEL_NAME" \
    --proxy-headers \
    --forwarded-allow-ips "${FORWARDED_ALLOW_IPS:-*}" \
    --host 127.0.0.1 \
    --port 8001 \
    "$@"
