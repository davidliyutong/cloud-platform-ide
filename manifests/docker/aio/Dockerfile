FROM davidliyutong/code-server-speit:latest-base

## Install iverilog
COPY manifests/install-scripts/setup-iverilog.sh /tmp/setup-iverilog.sh
RUN /bin/bash /tmp/setup-iverilog.sh

## Install Digital
COPY manifests/install-scripts/setup-digital.sh /tmp/setup-digital.sh
RUN /bin/bash /tmp/setup-digital.sh

# Misc
COPY .cache/home.aio.tar.xz /opt/home.tar.xz

RUN apt-get update && \
    apt-get install -y wxmaxima

# Clean Up
RUN apt-get clean && \
    apt-get autoclean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*


WORKDIR /root
EXPOSE 3000 80
CMD ["/usr/bin/supervisord"]
# ENTRYPOINT  [ "sh", "-c", "/usr/bin/docker-entrypoint.sh" ]