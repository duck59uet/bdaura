FROM postgres:13-alpine

COPY $HOME/database/schema /docker-entrypoint-initdb.d/
COPY $HOME/docker/psql/hasura_init.sh /docker-entrypoint-initdb.d/