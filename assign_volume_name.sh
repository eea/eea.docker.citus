#!/bin/bash

#sed 's/_/-/g' <- to make it work either in docker-compose or in rancher
if [ -z ${workernumber} ]; then
   workernumber=$(curl -s --unix-socket /var/run/docker.sock http://localhost/containers/json | jq -c '.[] | select( .Id | contains('\"$HOSTNAME\"'))' | jq '.Names[0]' | sed 's/_/-/g' | grep -o 'worker-.*' | cut -f2- -d- | cut -f1 -d '-'  | sed 's/"//g')
   echo setting PGDATA variable
   if [ -z ${workernumber} ]; then
     workernumber=master
   fi
   chown -R postgres:postgres /var/lib/postgres/data
   echo export PGDATA=/var/lib/postgresql/data/$workernumber > /pgdata.source
   echo export workernumber=$workernumber >> /pgdata.source
   rm -f /etc/sudoers.d/postgres.conf
fi

echo workernumber is: $workernumber

