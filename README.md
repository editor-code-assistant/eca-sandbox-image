# eca-sandbox-image

Docker image to run the [ECA](https://github.com/editor-code-assistant/eca) server sandboxed, from any editor.

Contains the `eca` binary plus a minimal toolset for agents (git, curl, ripgrep, unzip) on a Debian slim base.

Published for `linux/amd64` and `linux/arm64` as `ghcr.io/editor-code-assistant/eca-sandbox-image`, tagged with `latest` and the bundled ECA version (e.g. `0.152.0`). Rebuilt weekly to track new ECA releases.

## Usage

Point your editor's ECA server path at a wrapper script like:

```bash
#!/usr/bin/env bash
exec docker run --rm -i \
  -v "$PWD:$PWD" -w "$PWD" \
  -v "$HOME/.config/eca:/root/.config/eca:ro" \
  ghcr.io/editor-code-assistant/eca-sandbox-image:latest \
  eca "$@"
```

Check the [sandboxing docs](https://eca.dev/config/sandboxing/) for the full guide: per-editor setup, secrets, state persistence and caveats.

## Extending

Add your project toolchain so the agent can build and test inside the sandbox:

```dockerfile
FROM ghcr.io/editor-code-assistant/eca-sandbox-image:latest
RUN apt-get update && apt-get install -y --no-install-recommends nodejs npm
```

## Build locally

```bash
make
# or pinning a specific ECA version:
docker build --build-arg ECA_VERSION=0.152.0 -t eca/eca-sandbox-image .
```
