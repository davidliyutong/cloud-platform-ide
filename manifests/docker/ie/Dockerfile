FROM davidliyutong/code-server-speit:latest-base

## Install iverilog
COPY manifests/install-scripts/setup-iverilog.sh /tmp/setup-iverilog.sh
RUN /bin/bash /tmp/setup-iverilog.sh

## Install Digital
COPY manifests/install-scripts/setup-digital.sh /tmp/setup-digital.sh
RUN /bin/bash /tmp/setup-digital.sh

# Misc
COPY .cache/home.ie.tar.xz /opt/home.tar.xz

# Clean Up
RUN apt-get clean && \
    apt-get autoclean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*


WORKDIR /root
EXPOSE 3000 80 2222
ENTRYPOINT [ "/bin/bash" ]
CMD [ "/usr/bin/entrypoint.sh" ]