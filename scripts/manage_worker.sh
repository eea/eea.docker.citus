#!/bin/bash

POSTGRES_USER=postgres
POSTGRES_PASSWORD=changeme
POSTGRES_DB=postgres

ISREADY=$(PGPASSWORD=$POSTGRES_PASSWORD pg_isready -U $POSTGRES_USER -d $POSTGRES_DB -h $1 | grep accepting | cut -f2 -d '-' | xargs | cut -f1 -d ' ' | xargs)

if [[ $ISREADY = "accepting" ]]; then
  echo "$1 accepting connections"
  PGPASSWORD=$POSTGRES_PASSWORD psql -q -U $POSTGRES_USER -d $POSTGRES_DB -h master -c "SELECT * FROM citus_add_node('$CONTAINERNAME', 5432);"
else
  echo "$1 does not respond"
   PGPASSWORD=$POSTGRES_PASSWORD psql -q -U $POSTGRES_USER -d $POSTGRES_DB -h master -c "SELECT * FROM citus_disable_node('$CONTAINERNAME', 5432);"
fi

