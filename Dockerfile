FROM ubuntu:20.04

LABEL authoer="davidliyutong@sjtu.edu.cn"

ENV DEBIAN_FRONTEND=noninteractive
ENV PASSWORD ""

RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && \
    sed -i s@/security.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    htop \
    vim \
    wget \
    curl \
    tree \
    zsh \
    tmate \
    tmux \
    unzip \
    net-tools \
    traceroute \
    dnsutils \
    iputils-ping \
    lldb \
    htop \
    build-essential \
    gdb \
    clang \
    gcc \
    cmake \
    ninja-build \
    meson \
    jq \
    openssh-client \
    openssh-server

COPY ./code-server.tar.gz /tmp/code-server.tar.gz
RUN tar -zxf /tmp/code-server.tar.gz -C /usr/bin/ --strip-components=1

RUN apt-get clean && \
    apt-get autoclean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

COPY home.tar /tmp/home.tar
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod +x /usr/bin/docker-entrypoint.sh && chsh -s /bin/zsh

WORKDIR /root
EXPOSE 8080
ENTRYPOINT  [ "sh", "-c", "/usr/bin/docker-entrypoint.sh" ]