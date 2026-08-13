#!/usr/bin/env python
#
# Generates a random token for vLLM.
#

import sys, secrets

TOKEN_PREFIX = "vllm_"
TOKEN_BYTES_COUNT = 32


def gen_vllm_token(token_prefix, token_bytes_count):
    return token_prefix + secrets.token_hex(token_bytes_count)


if __name__ == "__main__":
    if len(sys.argv) != 1:
        sys.stderr.write("\n".join([
            "This script has to be run as:",
            f"{sys.argv[0]}",
            "",
        ]))
        sys.exit(1)
    sys.stdout.write(
        gen_vllm_token(TOKEN_PREFIX, TOKEN_BYTES_COUNT)
    )
