#!/bin/bash

echo installing POSTGIS extension with user \"$(whoami)\"
PGPASSWORD=$POSTGRES_PASSWORD psql -U postgres -c "CREATE EXTENSION postgis;"
