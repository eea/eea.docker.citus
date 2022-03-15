#!/bin/bash

container_name_pattern="eeadockercitus_worker_"

while true
do
  for node in {1..15}
  do
   /bin/bash /opt/manage_worker.sh $container_name_pattern$node &
  done
  echo "loop done, sleeping"  
  sleep 10
done


