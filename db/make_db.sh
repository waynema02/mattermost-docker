#!/bin/bash
set -e

MM_USERNAME=${MM_USERNAME:-mmuser}
MM_PASSWORD=${MM_PASSWORD:-mmuser_password}
MM_DBNAME=${MM_DBNAME:-mattermost}

psql -v ON_ERROR_STOP=1 --username "postgres" <<- EOSQL
    CREATE DATABASE $MM_DBNAME;
    CREATE USER $MM_USERNAME WITH PASSWORD '$MM_PASSWORD';
    GRANT ALL PRIVILEGES ON DATABASE $MM_DBNAME to $MM_USERNAME;
EOSQL

psql -v ON_ERROR_STOP=1 --username "postgres" mattermost -c <<- EOSQL
    CREATE EXTENSION zhparser'
    CREATE TEXT SEARCH CONFIGURATION simple_zh_cfg (PARSER = zhparser);'
    ALTER TEXT SEARCH CONFIGURATION simple_zh_cfg ADD MAPPING FOR n,v,a,i,e,l WITH simple;'
EOSQL
