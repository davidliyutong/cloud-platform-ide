FROM davidliyutong/code-server-speit:latest-base

RUN apt-get update && \
    apt-get install -y --fix-missing wxmaxima

# Misc
# COPY .cache/home.ie.tar.xz /opt/home.tar.xz

# Clean Up
RUN apt-get clean && \
    apt-get autoclean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*


WORKDIR /root
EXPOSE 3000 80
CMD ["/usr/bin/supervisord"]
# ENTRYPOINT  [ "sh", "-c", "/usr/bin/docker-entrypoint.sh" ]