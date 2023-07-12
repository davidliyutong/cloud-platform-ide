FROM fredblgr/ubuntu-novnc:20.04

LABEL author="davidliyutong@sjtu.edu.cn"

ENV DEBIAN_FRONTEND=noninteractive
ENV PASSWORD ""
ENV SHELL=/bin/zsh

# Change APT Source
RUN sed -i s@/archive.ubuntu.com/@/mirror.sjtu.edu.cn/@g /etc/apt/sources.list && \
    sed -i s@/security.ubuntu.com/@/mirror.sjtu.edu.cn/@g /etc/apt/sources.list

# Install packages
RUN apt-get update && apt-get install -y \
    python3 python3-pip \
    git htop vim wget curl tree zsh bison\
    tmate tmux \
    unzip zstd \
    net-tools traceroute dnsutils iputils-ping \
    htop \
    lldb build-essential gdb clang gcc gperf \
    graphviz ghdl openjdk-8-jre libncurses5-dev libreadline-dev flex \
    cmake ninja-build meson autoconf \
    jq \
    openssh-client openssh-server \
    supervisor
    # ubuntu-desktop gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal

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


## Install iverilog
COPY manifests/install-scripts/setup-iverilog.sh /tmp/setup-iverilog.sh
RUN /bin/bash /tmp/setup-iverilog.sh

## Install Digital
COPY manifests/install-scripts/setup-digital.sh /tmp/setup-digital.sh
RUN /bin/bash /tmp/setup-digital.sh

# Misc
COPY .cache/home.tar.gz /opt/home.tar.gz
COPY manifests/install-scripts/docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
COPY supervisord.conf.diff /tmp/supervisord.conf.diff
RUN chmod +x /usr/bin/docker-entrypoint.sh && \
    chsh -s /bin/zsh && \
    mkdir -p /var/log/supervisor && \
    cat /tmp/supervisord.conf.diff >> /etc/supervisor/conf.d/supervisord.conf

# Clean Up
RUN apt-get clean && \
    apt-get autoclean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*


WORKDIR /root
EXPOSE 8080
CMD ["/usr/bin/supervisord"]
# ENTRYPOINT  [ "sh", "-c", "/usr/bin/docker-entrypoint.sh" ]