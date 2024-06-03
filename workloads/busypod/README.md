The files contained in this direcotory serve to create an image of artificial workload container and can be used to generate a varying load (mainly in terms of CPU usage) in Kubernetes cluster using this image.

A simple example illustrating how a stream of pods can be generated to load the cluster with "dummy" work is available in the form of script **createpods.sh**. The script creates a number of busy pods with load characteristics defined by the values of the arguments being passed. 
Please, analyse the script for more details on its usage. For further details on how to parametrize the container/pod refer to the following Docker Hub repo: 

   https://hub.docker.com/repository/docker/dburszty/artificial-workload-amd64/general
   
