# Monitoring resource-level metrics

### Overall

In this experiment, we run a set of pods which we call workload or busy pods and monitor the occupacy of cluster resources as CPU and RAM (but more metrics can be monitored).

Our busypods are deployed by a bash script using our custom manifest of the pod. The script loops according to parameters provided in command line and a couple of encoded parameters. Details regarding how our container works (how it is created, etc.), are given in bash scripts contained in folder [workload/busypod](../workloads/busypod) and the references cited therein. Please, read this information. After studying the scripts and reading how the pod's container works, you will be able to change the parameters to regulate the load generated in the cluster and even modify the overall behavior of the container (the latter after modifying the code of the container application which is written in Python and generating new image).

### Tasks to do:

Use the artifacts available in the **[workload/busypod](../workloads/busypod)** folder.

1. Read the busypod container specification available in the [Dockerhub repo](https://hub.docker.com/r/dburszty/artificial-workload-arm64v8) and in the bash scripts in the [busypod folder](../workloads/busypod). Estimate the required values of script and container parameters to load the cluster to a given level, e.g., 30% utilization of CPU. Notice that the script with extension **createpods-random.sh** contains instructions that delete terminated pods (it is beneficial if the script runs for a long time, creates a lot of pods and the number of terminated pods becomes very large). You can adapt this part in your implementation (remaining scripts do not contain this deletion).
2. Run your script to deploy busypods and check if the load visible in Grafana matches (more or less) the value assumed in point 1. If the difference is huge, reevalute script/container parameters and re-run the experiment to check your cluster load again.
3. Sumarize your conclusions from this experiment.



