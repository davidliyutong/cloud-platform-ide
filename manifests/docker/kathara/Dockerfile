FROM davidliyutong/code-server-speit:latest-base

ENV PYTHONIOENCODING=utf-8
ARG UBUNTU_VERSION=20.04
ENV DOCKER_CHANNEL=stable \
    DOCKER_VERSION=27.2.1 \
    DOCKER_COMPOSE_VERSION=v2.29.2 \
    BUILDX_VERSION=v0.16.2 \
    DEBUG=false

# Install Docker's dependencies
RUN set -eux; \
    apt-get update && \
    apt-get install -y ca-certificates iptables

# Set iptables-legacy for Ubuntu 22.04 and newer
RUN set -eux; \
    if [ "${UBUNTU_VERSION}" != "20.04" ]; then \
        update-alternatives --set iptables /usr/sbin/iptables-legacy; \
    fi

# Install Docker and buildx
RUN set -eux; \
    arch="$(uname -m)"; \
    case "$arch" in \
        x86_64) dockerArch='x86_64' ; buildx_arch='linux-amd64' ;; \
        armhf) dockerArch='armel' ; buildx_arch='linux-arm-v6' ;; \
        armv7) dockerArch='armhf' ; buildx_arch='linux-arm-v7' ;; \
        aarch64) dockerArch='aarch64' ; buildx_arch='linux-arm64' ;; \
        *) echo >&2 "error: unsupported architecture ($arch)"; exit 1 ;; \
    esac && \
    wget -O docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/${dockerArch}/docker-${DOCKER_VERSION}.tgz" && \
    tar --extract --file docker.tgz --strip-components 1 --directory /usr/local/bin/ && \
    rm docker.tgz && \
    wget -O docker-buildx "https://github.com/docker/buildx/releases/download/${BUILDX_VERSION}/buildx-${BUILDX_VERSION}.${buildx_arch}" && \
    mkdir -p /usr/local/lib/docker/cli-plugins && \
    chmod +x docker-buildx && \
    mv docker-buildx /usr/local/lib/docker/cli-plugins/docker-buildx && \
    dockerd --version && \
    docker --version && \
    docker buildx version

# Install Docker Compose
RUN set -eux; \
    curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    docker-compose version && \
    ln -s /usr/local/bin/docker-compose /usr/local/lib/docker/cli-plugins/docker-compose

# Setup docker supervisord
COPY manifests/docker/kathara/modprobe /usr/local/bin/
COPY manifests/docker/kathara/supervisor/ /etc/supervisor/conf.d/

# Configure user permission
RUN groupadd docker && useradd -m -s /bin/bash -G docker ubuntu

RUN apt-get install -y software-properties-common && \
    add-apt-repository ppa:katharaframework/kathara && \
    apt-get install --fix-missing -y \
    kathara \
    nano gedit \
    xterm wireshark iperf iperf3 netcat tcpdump

# Install netcap from binary
RUN wget -O /tmp/netcap.tar.gz https://github.com/dreadl0ck/netcap/releases/download/v0.6.11/netcap_v0.6.11_linux_amd64_libc.tar.gz && \
    tar -xvf /tmp/netcap.tar.gz -C /tmp && \
    mv /tmp/netcap_v0.6.11_linux_amd64_libc/net /usr/bin/net && \
    chmod +x /usr/bin/net && \
    rm -rf /tmp/*

# Install Kathara Labs
RUN cd /opt && git clone https://github.com/KatharaFramework/Kathara-Labs.git

# COPY helper scripts
COPY manifests/tool-scripts/pull-kathara.sh /usr/bin/pull-kathara.sh
RUN chmod +x /usr/bin/pull-kathara.sh

# Misc
COPY .cache/home.kathara.tar.xz /opt/home.tar.xz

# Clean Up
RUN apt-get clean && \
    apt-get autoclean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# Overwrite entrypoint
COPY manifests/docker/kathara/entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

WORKDIR /root
EXPOSE 3000 80 2222
ENTRYPOINT [ "/bin/bash" ]
CMD [ "/usr/bin/entrypoint.sh" ]
