FROM ubuntu:26.04@sha256:53958ec7b67c2c9355df922dd08dbf0360611f8c3cdb656875e81873db9ffdba
ENV container=container
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      systemd systemd-sysv dbus dbus-user-session \
      docker.io docker-compose-v2 \
      iproute2 iputils-ping curl ca-certificates sudo vim-tiny && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# dockerd を起動時に自動起動
RUN systemctl enable docker

# machine 向けの systemd 調整
RUN systemctl set-default multi-user.target && \
    systemctl mask \
      dev-hugepages.mount sys-fs-fuse-connections.mount \
      systemd-update-utmp.service console-getty.service && \
    printf '' > /etc/machine-id
