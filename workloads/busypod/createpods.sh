#!/bin/bash

# The script creates a number of busypods with load characteristics defined by the values of arguments being passed.
# For details about parametrizing the pod refer to the Docker Hub repo: 
#   https://hub.docker.com/repository/docker/dburszty/artificial-workload-amd64/general

PODS_TO_CREATE=1
NAMESPACE="congestion"
PODPREFIX="congest"
IMAGE="dburszty/artificial-workload-arm64v8:latest"

kubectl create namespace $NAMESPACE > /dev/null 2>&1
#kubectl create namespace $NAMESPACE

i=0
cont=true

while $cont
do

  # pod name will contain: a fixed prefix - consecutive integer number - unigue suffix expressing milliseconds elapsed from Epoch
  i=$((i+1))
  name="$PODPREFIX-$i-"$(date +%s%3N)
  echo $name
  
#  examples 
#  kubectl run -n $NAMESPACE $name --image=$IMAGE --restart=Never -- 10000 5 oiter=1
#  with default values: kubectl run -n $NAMESPACE $name --image=$IMAGE --restart=Never
#  with run time equal ~30 sec: 
  kubectl run -n $NAMESPACE $name --image=$IMAGE --restart=Never -- 10000 5 otime=30
  
  # we set sleeptime = 2.5 + random[0 ... 1] sec.
  base=2.5
  denom=32767                # because $RAND in [0..32767]
  sleeptime=$(echo "scale=4; $base + $RANDOM / $denom" | bc)   # use bc - basic calculator utility for floating
  echo "sleep = $sleeptime"
  sleep $sleeptime

  if [ $i == $PODS_TO_CREATE ]; then
    cont=false
  fi
  
done

echo "Exiting, created pods: $i."
