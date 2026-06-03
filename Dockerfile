FROM ghcr.io/anomalyco/opencode:latest

ARG BUN_RUNTIME_TRANSPILER_CACHE_PATH=0
ENV BUN_RUNTIME_TRANSPILER_CACHE_PATH=${BUN_RUNTIME_TRANSPILER_CACHE_PATH} \
    OPENCODE_DISABLE_AUTOUPDATE=true \
    OPENCODE_DISABLE_LSP_DOWNLOAD=true

RUN apk add --no-cache \
    git \
    openssh-client \
    nodejs \
    npm \
    python3 \
    bash \
    curl \
    jq \
    fd \
    bat \
    tree \
    tmux \
    nano

WORKDIR /workspace
EXPOSE 4096

ENTRYPOINT ["opencode"]
CMD ["web", "--hostname", "0.0.0.0", "--port", "4096"]
