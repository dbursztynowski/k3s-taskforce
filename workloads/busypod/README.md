Files used to create an image and run varying load in a cluster using artificial workload container image.

A simple example how a steam of pods can be generated to load the cluster with "dummy" work is presented in the script createpods.sh. 
The script creates a number of busy pods with load characteristics defined by the values of the arguments being passed. 
Please, analyse the script for more details on its usage.

For details about parametrizing the container/pod refer to the following Docker Hub repo: 

   https://hub.docker.com/repository/docker/dburszty/artificial-workload-amd64/general
   
