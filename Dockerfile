FROM mysql:latest

COPY assets/friendcore.sql /docker-entrypoint-initdb.d/
