FROM citusdata/citus:10.2.3

RUN apt-get -y update && \
    apt-get -y install curl \
    jq \
    postgresql-14-postgis-3 \
    postgresql-14-postgis-3-scripts \
    libldap-common \
    sudo 

RUN sed "s#if ! _is_sourced; then#/assign_volume_name.sh\nsource /pgdata.source\nif ! _is_sourced; then#g" -i /usr/local/bin/docker-entrypoint.sh

RUN echo 'ALL  ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/postgres.conf && \
    echo 'Defaults:ALL !requiretty' >> /etc/sudoers.d/postgres.conf

COPY assign_volume_name.sh /
COPY scripts/00* /docker-entrypoint-initdb.d/
