# Monitoring resource-level metrics

### Overall

In this experiment, we run a set of pods which we call workload or busy pods and monitor the occupacy of cluster resources as CPU and RAM (but more metrics can be monitored).

Our busypods are deployed by a bash script using our custom manifest of the pod. The script loops according to parameters values encoded inside it. Details regarding how our container works (how it is created, etc.), are given in bash scripts contained in folder busypod and the references cited therein. Please, read this information. After studying the scripts and reading how the pod's container works, you will be able to change the parameters to regulate the load generated in the cluster and (after modifying the code of the container application which is written in Python) even the overall behavior of the container. Do not hesitate to customize the script(s) or the container application according to your needs.

### Tasks to do:

1. Read busypod container specification in the Docker repo and the bash scripts in the busypod folder. Estimate the required values of script and container parameters to load the cluster to a given level, e.g., 30% utilization of CPU. Notice that the script with extension **.org** contains instructions that delete terminated pods (its beneficial if the script creates a lot of pods). You can adapt this part in your implementation (remaining scripts do not contain this deletion).
2. Run your script to deploy busypods and check if the load visible in Grafana matches (more or less) the value assumed in point 1. If the difference is huge, reevalute script/container parameters and re-run the experiment to check your cluster load again.
3. Sumarize your conclusions from this experiment.



