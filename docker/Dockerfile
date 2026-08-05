FROM vllm/vllm-openai:latest

# Install nginx without starting it and clean apt cache in a single layer
RUN printf '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && \
    chmod +x /usr/sbin/policy-rc.d && \
    apt-get update && apt-get install -y nginx && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    rm /usr/sbin/policy-rc.d

# Create deployment directories
RUN mkdir -p /etc/nginx/sites-disabled /app/bin

# Place the config into the available sites
COPY vllm-proxy.conf /etc/nginx/sites-available/vllm-proxy.conf

# Activate the config and deactivate existing defaults
RUN mv /etc/nginx/sites-enabled/* /etc/nginx/sites-disabled/ && \
    ln -s /etc/nginx/sites-available/vllm-proxy.conf /etc/nginx/sites-enabled/vllm-proxy.conf

# Inject and prepare the nginx/vLLM entrypoint
COPY entrypoint.sh /app/bin/entrypoint.sh
RUN chmod +x /app/bin/entrypoint.sh

ENTRYPOINT ["/app/bin/entrypoint.sh"]
