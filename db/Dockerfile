FROM postgres:9.4

RUN apt-get update \
    && apt-get install -y python-dev lzop pv daemontools curl build-essential \
    && curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | python \
    && pip install wal-e \
    && curl -L http://www.xunsearch.com/scws/down/scws-1.2.2.tar.bz2 | tar xjf - \
    && cd scws-1.2.2 \
    && ./configure \
    && make install \
    && cd .. \
    && curl -L https://github.com/amutu/zhparser/archive/master.zip | unzip - \
    && cd zhparser-master \
    && apt-get install --yes postgresql-server-dev-9.4 libpq-dev \
    && SCWS_HOME=/usr/local make && make install \
    && apt-get install sudo \
    && PGDATA=/var/lib/postgresql/data sudo -E -u postgres /usr/lib/postgresql/9.4/bin/psql mattermost -c 'CREATE EXTENSION zhparser'
    && PGDATA=/var/lib/postgresql/data sudo -E -u postgres /usr/lib/postgresql/9.4/bin/psql mattermost -c 'CREATE TEXT SEARCH CONFIGURATION simple_zh_cfg (PARSER = zhparser);'
    && PGDATA=/var/lib/postgresql/data sudo -E -u postgres /usr/lib/postgresql/9.4/bin/psql mattermost -c 'ALTER TEXT SEARCH CONFIGURATION simple_zh_cfg ADD MAPPING FOR n,v,a,i,e,l WITH simple;'
    && cd /var/lib/postgresql/ \
    && sed -i "s/default_text_search_config = 'pg_catalog.english'/default_text_search_config = 'simple_zh_cfg'/" postgresql.conf
    && PGDATA=/var/lib/postgresql/data sudo -E -u postgres /usr/lib/postgresql/9.4/bin/pg_ctl reload
    && apt-get remove -y build-essential python-dev \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD make_db.sh /docker-entrypoint-initdb.d/
ADD setup-wale.sh /docker-entrypoint-initdb.d/
COPY docker-entrypoint1.sh /
RUN chmod +x /docker-entrypoint1.sh

ENTRYPOINT ["/docker-entrypoint1.sh"]

CMD ["postgres"]
