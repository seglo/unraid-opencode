# unraid-opencode

Extended Docker image for [OpenCode](https://opencode.ai) with tooling needed for full functionality on Unraid and other Docker hosts.

The [official image](https://github.com/anomalyco/opencode/pkgs/container/opencode) (`ghcr.io/anomalyco/opencode`) is a minimal Alpine image with only the `opencode` binary and `ripgrep`. It lacks git, Node.js, SSH, and other essentials. This image adds everything needed for VCS operations, MCP server spawning, and a comfortable development environment.

## What's added

| Package | Purpose |
|---------|---------|
| `git` | VCS operations (commit, push, diff) |
| `openssh-client` | SSH for git remotes |
| `nodejs` / `npm` | MCP servers that spawn local processes |
| `python3` | Python-based tools and MCP servers |
| `bash` | Shell for interactive terminal |
| `curl` / `jq` | HTTP requests and JSON processing |
| `fd` / `bat` / `tree` | File finding, viewing, and listing |
| `tmux` / `nano` | Terminal multiplexing and editing |

## Usage

### Docker CLI

```bash
docker run -d \
  --name opencode \
  -p 4096:4096 \
  -v /path/to/config:/root/.config/opencode \
  -v /path/to/data:/root/.local/share/opencode \
  -v /path/to/workspace:/workspace \
  -v /path/to/ssh:/root/.ssh \
  -v /path/to/gitconfig:/root/.gitconfig \
  -e OPENCODE_SERVER_PASSWORD=your-password \
  -e ANTHROPIC_API_KEY=sk-ant-... \
  ghcr.io/seglo/unraid-opencode:latest
```

### Docker Compose

```yaml
services:
  opencode:
    image: ghcr.io/seglo/unraid-opencode:latest
    ports:
      - "4096:4096"
    environment:
      - OPENCODE_SERVER_PASSWORD=your-password
      - ANTHROPIC_API_KEY=sk-ant-...
      - TZ=America/New_York
    volumes:
      - ./config:/root/.config/opencode
      - ./data:/root/.local/share/opencode
      - ./workspace:/workspace
      - ./ssh:/root/.ssh
      - ./gitconfig:/root/.gitconfig
    restart: unless-stopped
```

### Access

Open `http://localhost:4096` in your browser. Log in with username `opencode` and the password you set.

### Attach from local TUI

```bash
opencode attach http://your-server:4096
```

## Unraid

An Unraid template is included at [`templates/unraid-opencode.xml`](templates/unraid-opencode.xml). Add it via Community Apps or the Docker tab with the template URL:

```
https://raw.githubusercontent.com/seglo/unraid-opencode/main/templates/unraid-opencode.xml
```

## Configuration

| Volume | Container Path | Purpose |
|--------|---------------|---------|
| Config | `/root/.config/opencode` | `opencode.json`, agents, commands, plugins |
| Data | `/root/.local/share/opencode` | Sessions, auth, snapshots, database |
| Workspace | `/workspace` | Your projects |
| SSH | `/root/.ssh` | SSH keys for git |
| GitConfig | `/root/.gitconfig` | Git user config |

### Key environment variables

| Variable | Description |
|----------|-------------|
| `OPENCODE_SERVER_PASSWORD` | Enable HTTP basic auth (recommended) |
| `OPENCODE_SERVER_USERNAME` | Override auth username (default: `opencode`) |
| `OPENCODE_CONFIG_CONTENT` | Inline JSON config (highest precedence) |
| `OPENCODE_DISABLE_AUTOUPDATE` | Disable update checks (default: `true`) |

See [OpenCode docs](https://opencode.ai/docs/config) for full configuration reference.

## Image tags

| Tag | Description |
|-----|-------------|
| `latest` | Latest build from `main` branch |
| `1.15.13` | Pinned to a specific OpenCode release |
| `sha-abc1234` | Git SHA for reproducibility |

Images are published to `ghcr.io/seglo/unraid-opencode` for both `linux/amd64` and `linux/arm64`.

## License

MIT
