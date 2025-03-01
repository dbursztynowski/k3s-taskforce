## **Monitoring resource level metrics

In this experiment, we run a set of pods which we call workload or busy pods and monitor the occupacy of cluster resources as CPU and RAM (but more metrics can be monitored).

Our busypods are deployed based on our custom manifest by a bash script that loops according to parameters encoded inside it. Details regarding how those pods work, how they are created, etc., are given in folder busypod [workloads/busypod/createpods.sh] and the references cited therein. Please, read this information. Moreover, after reading how the pod's container works, you will be able to change its parameters to regulate the load put onto to cluster and (after modifying the code of the application which is simple Python code) even the overall behavior of the container.

Tasks to do:

1. Read busypod specification and try to calculate pod parameters to load the cluster to a given level, e.g., 30% utilization of RAM.
2. Run the script deploying the pods and check if the load visible in Prometheus matches (more or less) the assumed value. If the difference is huge, reevalute pod parameters and re-run the experiment to check cluster load again.



