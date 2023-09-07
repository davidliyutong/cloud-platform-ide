FROM davidliyutong/code-server-speit:latest-base

RUN apt-get update && \
    apt-get install -y --fix-missing wxmaxima

## Install GeoGeBra
COPY manifests/install-scripts/setup-geogebra.sh /tmp/setup-geogebra.sh
RUN /bin/bash /tmp/setup-geogebra.sh

# Misc
# COPY .cache/home.ie.tar.xz /opt/home.tar.xz

# Clean Up
RUN apt-get clean && \
    apt-get autoclean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*


WORKDIR /root
EXPOSE 3000 80 2222
ENTRYPOINT [ "/bin/bash" ]
CMD [ "/usr/bin/entrypoint.sh" ]