FROM debian:stable-slim

ARG TARGETARCH
ARG ECA_VERSION=latest

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        ripgrep \
        unzip \
    && rm -rf /var/lib/apt/lists/*

# Mounted workspaces belong to the host user while the container runs as root,
# without this git refuses to operate on them (dubious ownership).
RUN git config --global --add safe.directory '*'

RUN if [ "$TARGETARCH" = "arm64" ]; then ARCH="aarch64"; else ARCH="amd64"; fi && \
    if [ "$ECA_VERSION" = "latest" ]; then \
        URL="https://github.com/editor-code-assistant/eca/releases/latest/download/eca-native-linux-${ARCH}.zip"; \
    else \
        URL="https://github.com/editor-code-assistant/eca/releases/download/${ECA_VERSION}/eca-native-linux-${ARCH}.zip"; \
    fi && \
    curl -fsSL "$URL" -o /tmp/eca.zip && \
    unzip -q /tmp/eca.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/eca && \
    rm /tmp/eca.zip

WORKDIR /workspace

CMD ["eca", "server"]
