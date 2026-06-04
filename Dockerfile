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
    py3-pip \
    bash \
    curl \
    jq \
    fd \
    bat \
    tree \
    tmux \
    nano

# Add uv and locally installed tools to PATH
ENV PATH="/root/.local/bin:$PATH"

# Install uv for Python package management (needed for ha-mcp)
RUN pip3 install --break-system-packages --no-cache-dir uv

# Pre-install MCP server npm packages for faster startup
RUN npm install -g \
    gogcli-mcp-gmail \
    mcp-google-drive

# Install ha-mcp via uv
RUN uv tool install ha-mcp

WORKDIR /workspace
EXPOSE 4096

ENTRYPOINT ["opencode"]
CMD ["web", "--hostname", "0.0.0.0", "--port", "4096"]
