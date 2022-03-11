FROM ubuntu:18.04

# Fix timezone issue, see: https://bugs.launchpad.net/ubuntu/+source/tzdata/+bug/1554806
RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime
# RUN dpkg-reconfigure -f noninteractive tzdata

RUN apt update --fix-missing
RUN apt install -y postgresql postgresql-server-dev-10 build-essential curl python-pip psmisc

RUN pip install awscli

WORKDIR /tmp
RUN curl -L -o pgpool-II-4.0.6.tar.gz http://www.pgpool.net/download.php?f=pgpool-II-4.0.6.tar.gz
RUN tar xf pgpool-II-4.0.6.tar.gz

WORKDIR /tmp/pgpool-II-4.0.6
RUN ./configure
RUN make
RUN make install

WORKDIR /tmp/pgpool-II-4.0.6/src/sql
RUN make
RUN make install

RUN rm -rf /tmp/*

RUN mkdir -p /var/run/pgpool
RUN mkdir -p /var/log/pgpool
RUN chmod -R 777 /var/run/pgpool 
RUN chmod -R 777 /var/run/pgpool

ENV MASTER_NODE_PORT 5432
ENV REPLICA_NODE_PORT 5432
ENV DB_NAME postgres
ENV DB_USERNAME postgres
ENV DB_PASSWORD postgres

EXPOSE 9999
EXPOSE 9000

WORKDIR /usr/local/bin
COPY docker-entrypoint.sh /usr/local/bin
RUN chmod 777 ./docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["pgpool", "-n", "-D"]