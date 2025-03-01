## **Monitoring resource level metrics

In this experiment, we run a set of pods which we call workload or busy pods and monitor the occupacy of cluster resources as CPU and RAM (but more metrics can be monitored).

Our busypods are created from our custom manifest. Details regarding how those pods work, how they are created, etc., are given in folder busypod and the references cited therein. Please, read this information. Moreover, after reading how the pod's container works, you will be able to change its parameters to regulate the load put onto to cluster and (after modifying the code of the application which is simple Python code) even the overall behavior of the container.

Tasks to do:



