#!/bin/bash

###################################################

# The script creates a number of busypods with load characteristics defined by the values of arguments being passed.
# For details about parametrizing the container refer to the Docker Hub repo: 
#   https://hub.docker.com/repository/docker/dburszty/artificial-workload-amd64/general or
#   https://hub.docker.com/repository/docker/dburszty/artificial-workload-arm64v8/general

#The characteristics of the load are determined by container parameters (see the links above) and by the variables defined below.

# Adjust the number of pods to be created.
# Notice that setting PODS_TO_CREAT to negative number makes the while loop generate an "infinite" number of pods.
PODS_TO_CREATE=1

# The inter-pod arrival time (sleeptime) will be equal to ( $BASE_INTERPOD_TIME + random-duration-from[0..1] seconds )
# One can modify this strategy according to her/his needs
BASE_INTERPOD_TIME=2.5

# Namespace to be created
NAMESPACE="congestion"

# Pod's name prefix
PODPREFIX="congest"

# Choose appropriate architecture: amd64 or arm64v8
IMAGE="dburszty/artificial-workload-arm64v8:latest"

###################################################

kubectl create namespace $NAMESPACE > /dev/null 2>&1    # > /dev/null 2>&1   - ignores command output

i=0
cont=true
while $cont
do

  # SET POD NAME ==========
  # pod name will contain: <fixed prefix>-<consecutive integer number>-<unigue suffix expressing milliseconds elapsed from Epoch>
  i=$((i+1))
  name="$PODPREFIX-$i-"$(date +%s%3N)
  echo $name

  # RUN THE POD ===========
  # examples 
  #kubectl run -n $NAMESPACE $name --image=$IMAGE --restart=Never -- 10000 5 oiter=1
  #with default values: kubectl run -n $NAMESPACE $name --image=$IMAGE --restart=Never
  #with run time equal ~30 sec: 
  kubectl run -n $NAMESPACE $name --image=$IMAGE --restart=Never -- 10000 5 otime=30

  # SLEEP TIME ============
  if [ $i != $PODS_TO_CREATE ]; then
    # we set sleeptime = $BASE_INTERPOD_TIME + random-number[0 ... 1] seconds
    denom=32767                # because $RAND is from the interval [0..32767]
    sleeptime=$(echo "scale=4; $BASE_INTERPOD_TIME + $RANDOM / $denom" | bc)   # use bc - Basic Calculator utility for floating point
    #echo "sleep = $sleeptime"
    sleep $sleeptime
  else
    cont=false
  fi
  
done

echo "Exiting, number of created pods: $i."
