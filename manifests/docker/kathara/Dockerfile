FROM fredblgr/ubuntu-novnc:20.04

LABEL author="davidliyutong@sjtu.edu.cn"

ENV DEBIAN_FRONTEND=noninteractive
ENV PASSWORD ""
ENV SHELL=/bin/zsh
ENV PYTHONIOENCODING=utf-8

ARG UBUNTU_VERSION=20.04
ENV DOCKER_CHANNEL=stable \
    DOCKER_VERSION=27.2.1 \
    DOCKER_COMPOSE_VERSION=v2.29.2 \
    BUILDX_VERSION=v0.16.2 \
    DEBUG=false

# Install common dependencies
RUN set -eux; \
    apt-get update && apt-get install -y \
    ca-certificates wget curl iptables supervisor \
    && rm -rf /var/lib/apt/lists/*

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

VOLUME /var/lib/docker

# Install Docker Compose
RUN set -eux; \
    curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    docker-compose version && \
    ln -s /usr/local/bin/docker-compose /usr/local/lib/docker/cli-plugins/docker-compose

# Change APT Source
RUN sed -i s@/archive.ubuntu.com/@/mirror.sjtu.edu.cn/@g /etc/apt/sources.list && \
    sed -i s@/security.ubuntu.com/@/mirror.sjtu.edu.cn/@g /etc/apt/sources.list

# Install packages
RUN apt-get update && apt-get install --fix-missing -y \
    python3 python3-pip \
    git htop vim nano wget curl tree zsh bison\
    tmate tmux \
    unzip zstd \
    net-tools traceroute dnsutils iputils-ping \
    htop \
    lldb build-essential gdb clang gcc gperf \
    graphviz ghdl openjdk-8-jre libncurses5-dev libreadline-dev flex \
    cmake ninja-build meson autoconf \
    jq \
    openssh-client openssh-server \
    openssh-server \
    flatpak \
    rsync \
    supervisor

# RUN flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install Miniconda
RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    /bin/bash /tmp/miniconda.sh -b -p /opt/miniconda3 && \
    rm /tmp/miniconda.sh

# Configure Python environment
RUN . /opt/miniconda3/etc/profile.d/conda.sh && conda activate && \
    pip install -U pip && \
    pip config set global.index-url https://mirror.sjtu.edu.cn/pypi/web/simple && \
    pip install sympy numpy matplotlib scipy scikit-learn networkx pandas pydot graphviz jupyter && \
    pip install symbtools ipydex ipython && \
    pip install pycartan

# Install code-server
COPY .cache/code-server.tar.gz /tmp/code-server.tar.gz
RUN mkdir /usr/lib/code-server && \
    tar -zxf /tmp/code-server.tar.gz -C /usr/lib/code-server --strip-components=1 && \
    rm /tmp/code-server.tar.gz && \
    ln -s /usr/lib/code-server/bin/code-server /usr/bin/code-server

RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:katharaframework/kathara && \
    apt-get update && \
    apt-get install -y kathara xterm wireshark iperf iperf3 golang-go netcat tcpdump

# RUN export GOPROXY=https://goproxy.cn ; \
#     go get -u github.com/dreadl0ck/netcap/... && \
#     cd /opt && git clone https://github.com/KatharaFramework/Kathara-Labs.git

# Misc
COPY .cache/websocat /usr/bin/websocat
RUN mkdir -p /run/sshd && \
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config && \
    chmod +x /usr/bin/websocat

COPY .cache/home.base.tar.xz /opt/home.tar.xz
COPY manifests/install-scripts/entrypoint.sh /usr/bin/entrypoint.sh
COPY manifests/supervisord.conf.diff /tmp/supervisord.conf.diff

COPY manifests/docker/kathara/modprobe manifests/docker/kathara/start-docker.sh manifests/docker/kathara/entrypoint.sh /usr/local/bin/
COPY manifests/docker/kathara/supervisor/ /etc/supervisor/conf.d/
COPY manifests/docker/kathara/logger.sh /opt/bash-utils/logger.sh
COPY manifests/docker/kathara/kathara_prepare.sh /usr/local/bin/kathara_prepare.sh

RUN chmod +x /usr/bin/entrypoint.sh && \
    chsh -s /bin/zsh && \
    mkdir -p /var/log/supervisor && \
    chmod -x /usr/local/bin/kathara_prepare.sh && \
    cat /tmp/supervisord.conf.diff >> /etc/supervisor/conf.d/supervisord.conf

# Clean Up
RUN apt-get clean && \
    apt-get autoclean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*


# Allow 'ubuntu' to run sudo commands without password by modifying the sudoers file
RUN echo "ubuntu ALL=(ALL:ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo
RUN groupadd docker && useradd -m -s /bin/bash -G docker ubuntu

# USER ubuntu
WORKDIR /home/ubuntu
ENV SHELL=/bin/zsh \
    USERNAME=ubuntu \
    USERID=1000 \
    PASSWORD=ubuntu
EXPOSE 3000 80 2222
ENTRYPOINT [ "/bin/bash" ]
CMD [ "/usr/bin/entrypoint.sh" ]