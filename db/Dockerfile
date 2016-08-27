FROM postgres:9.4

SCWS_VERSION=1.2.2
ZHPARSER_VERSION=de966445dab64b91378527219988f36107b7b2e8

RUN apt-get update \
    && apt-get install -y python-dev lzop pv daemontools curl build-essential \
    && apt-get install --yes postgresql-server-dev-9.4 libpq-dev unzip \
    && curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | python \
    && pip install wal-e \
    && curl -L http://www.xunsearch.com/scws/down/scws-$(SCWS_VERSION).tar.bz2 | tar xjf - \
    && cd scws-$(SCWS_VERSION)  && ./configure  && make install \
    && cd ../ && rm -rf scws-$(SCWS_VERSION) \
    && curl -L --silent --show-error --retry 10 https://github.com/amutu/zhparser/archive/$(ZHPARSER_VERSION).zip > temp.zip \
    && unzip temp.zip && rm temp.zip \  
    && cd zhparser-$(ZHPARSER_VERSION) \
    && SCWS_HOME=/usr/local make && make install \
    && cd ../ && rm -rf zhparser-$(ZHPARSER_VERSION) \
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
