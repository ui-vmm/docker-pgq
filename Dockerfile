FROM postgres:14-bullseye

RUN set -ex && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    postgresql-server-dev-14 \
    python3-docutils \
    ca-certificates \
    libtool \
    libevent-dev \
    libpq-dev \
    autoconf \
    automake \
    autotools-dev \
    pkg-config \
    make \
    git && \
    git clone https://github.com/pgq/pgqd && \
    git clone https://github.com/pgq/pgq-coop && \
    git clone https://github.com/pgq/pgq && \
    cd pgqd && \
    git submodule update --init && \
    ./autogen.sh && \
    ./configure --prefix=/usr/local && \
    make && \
    make install && \
    cd ../pgq && \
    make && \
    make install && \
    cd ../pgq-coop && \
    make && \
    make install && \
    apt clean autoclean && \
    apt autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log} && \
    mkdir /tempdb && \
    chown -R postgres:postgres /tempdb && \
    su postgres -c 'pg_ctl -D /tempdb init' && \
    su postgres -c 'pg_ctl -D /tempdb start' && \
    su postgres -c 'psql -c "CREATE EXTENSION IF NOT EXISTS pgq;"' && \
    su postgres -c 'psql -c "CREATE EXTENSION IF NOT EXISTS pgq_coop;"' && \
    su postgres -c 'pg_ctl -D /tempdb --mode=immediate stop' && \
    rm -rf /tempdb && \
    pgqd --ini | sed \
    -e 's|logfile .*|logfile = /tmp/pgqd.log|g' \
    -e 's|pidfile .*|pidfile = /tmp/pgqd.pid|g' > /etc/pgqd.ini && \
    mkdir -p /docker-entrypoint-initdb.d

RUN sed -i "s|_main |su postgres -c 'pgqd /etc/pgqd.ini' \&\n\t_main |" /usr/local/bin/docker-entrypoint.sh

COPY ./initdb-pgq.sh /docker-entrypoint-initdb.d/10_pgq.sh
