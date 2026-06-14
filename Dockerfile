# Stage 1: Download game assets using a standard amd64 container (avoids i386 DNS issues)
FROM debian:bullseye-slim AS downloader
RUN apt-get update && apt-get install -y --no-install-recommends wget unzip \
    && rm -rf /var/lib/apt/lists/*
ARG ASSETS_URL=https://static.soldat.pl/downloads/soldatserver2.8.2_1.7.1.1.zip
# Extract directly to /tmp — the zip contains a single top-level dir (soldatserver2.8.2_1.7.1/)
RUN wget -q --no-check-certificate "${ASSETS_URL}" -O /tmp/assets.zip \
    && unzip -o /tmp/assets.zip -d /tmp/

# Stage 2: Runtime image (32-bit to match the soldatserver binary)
FROM i386/debian:bullseye-slim
RUN useradd -r -u 1000 -d /soldat -s /sbin/nologin soldat
WORKDIR /soldat
# Copy from the actual extracted subdirectory so assets land directly in /soldat/
COPY --from=downloader /tmp/soldatserver2.8.2_1.7.1/ /soldat/
RUN chmod +x /soldat/soldatserver \
    && rm -f /soldat/soldatserver.exe /soldat/soldatserver_arm \
    && mkdir -p /soldat/logs /soldat/anti-cheat
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh \
    && chown -R soldat:soldat /soldat
EXPOSE 23073/udp 23073/tcp 23083/tcp
USER soldat
ENTRYPOINT ["/entrypoint.sh"]
