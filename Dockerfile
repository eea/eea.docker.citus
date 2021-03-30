FROM citusdata/citus:latest
#10.0.3-pg13.2-1 at the time of first commit.

RUN apt-get -y update && \
    apt-get -y install curl \
    jq \
    postgresql-13-postgis-3 \
    postgresql-13-postgis-3-scripts \
    sudo

RUN sed "s#if ! _is_sourced; then#/assign_volume_name.sh\nsource /pgdata.source\nif ! _is_sourced; then#g" -i /usr/local/bin/docker-entrypoint.sh

RUN echo 'ALL  ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/postgres.conf && \
    echo 'Defaults:ALL !requiretty' >> /etc/sudoers.d/postgres.conf

COPY assign_volume_name.sh /
COPY scripts/002-installpostgis.sh /docker-entrypoint-initdb.d/002-installpostgis.sh
