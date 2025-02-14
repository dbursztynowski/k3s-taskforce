The files contained in this direcotory serve to create an image of artificial workload container that can be used to generate variable load (in terms of CPU utilization) in Kubernetes cluster.

A simple example illustrating how a stream of pods can be generated to load the cluster with artificial work is available in the form of script **createpods.sh**. The script creates a number of busy pods with load (usage) characteristics defined by the arguments being passed to each pod at creation time. For more details on how to parametrize the container/pod refer to the following Docker Hub repo (amd64 and arm64v8 versions of the image are currently available out of the box): 

   https://hub.docker.com/repository/docker/dburszty/artificial-workload-amd64/general
   
   https://hub.docker.com/repository/docker/dburszty/artificial-workload-arm64v8/general
   
