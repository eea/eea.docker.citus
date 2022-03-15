#!/bin/bash

#sed 's/_/-/g' <- to make it work either in docker-compose or in rancher
if [[ -z ${workernumber} ]]; then
   #RANCHER SPECIFIC
   #workernumber=$(curl -s --unix-socket /var/run/docker.sock http://localhost/containers/json | jq -c '.[] | select( .Id | contains('\"$HOSTNAME\"'))' | jq '.Names[0]' | sed 's/_/-/g' | grep -o 'worker-.*' | cut -f2- -d- | cut -f1 -d '-'  | sed 's/"//g')
   #DOCKER SPECIFIC
   workernumber=$(curl -s --unix-socket /var/run/docker.sock http://localhost/containers/json | jq -c '.[] | select( .Id | contains('\"$HOSTNAME\"'))' | jq '.Names[0]' | sed 's/_/-/g' | grep -o 'worker-.*' | cut -f2- -d- | cut -f1 -d '-' | cut -f1 -d '"')
   echo setting PGDATA variable
   if [[ -z ${workernumber} ]]; then
     workernumber=master
   fi
   chown -R postgres:postgres /var/lib/postgres/data
   echo export PGDATA=/var/lib/postgresql/data/$workernumber > /pgdata.source
   echo export workernumber=$workernumber >> /pgdata.source
   rm -f /etc/sudoers.d/postgres.conf
fi

#if [[ $ROLE = "Worker" ]]; then
#  CONTAINERNAME=$(curl -s --unix-socket /var/run/docker.sock http://localhost/containers/json | jq -c '.[] | select( .Id | contains('\"$HOSTNAME\"'))' | jq '.Names[0]' | cut -f2 -d '/' | cut -f1 -d '"' | sed 's?-[^-]*$??' | sed 's/r-//')
#  #curl -s --unix-socket /var/run/docker.sock http://localhost/containers/json | jq -c '.[] | select( .Id | contains('\"$HOSTNAME\"'))' | jq '.Names[0]'  | sed 's/_/-/g' | grep -o '\-.*' | cut -f2- -d- | sed 's?-[^-]*$??')
#  echo CONTAINERNAME: $CONTAINERNAME
#  while true; do
#    ISMASTERREADY=$(PGPASSWORD=$POSTGRES_PASSWORD pg_isready -U $POSTGRES_USER -d $POSTGRES_DB -h master | grep accepting | cut -f2 -d '-' | xargs | cut -f1 -d ' ' | xargs)
#    if [[ $ISMASTERREADY = "accepting" ]]; then
#      echo "Master is up"
#      break
#    fi
#    echo -e "\nMaster node not started, waiting ...\n"
#    sleep 1
#  done

#  #registerig the node to the cluster, but disabling it as we do not know if the worker will start at this stage
#  PGPASSWORD=$POSTGRES_PASSWORD psql -U $POSTGRES_USER -d $POSTGRES_DB -h master -c "SELECT * FROM citus_add_node('$CONTAINERNAME', 5432);"
#  PGPASSWORD=$POSTGRES_PASSWORD psql -U $POSTGRES_USER -d $POSTGRES_DB -h master -c "SELECT * FROM citus_disable_node('$CONTAINERNAME', 5432);"
#fi

echo workernumber is: $workernumber
