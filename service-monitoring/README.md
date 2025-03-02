# Monitoring service-level metrics
## Introduction
The main objective of this part of the laboratory is to provide basic knowledge of service monitoring that can be used during service orchestration where decision-making is based on service level indicators. This should be clearly distinguished from resource monitoring and resource-level management/orchestration.

The scenario involves monitoring emulated 5G network. The RAN part of the network will be emulated using UERANSIM, 5G core will be built upon containerized Open5GS platform, and the deployment of both components will be based on slightly customized Gradiant Helm charts.

Since the focus of this lab is on service level orchestration, the topic of 5G network configuration and deployment is only very briefly discussed. We will only cover the absolute minimum necessary to enable a 5G environment and manage the number of active terminals in the network. Then we will monitor the selected service-level metric using Prometheus. This will underpin our understanding of service monitoring in preparation to Project 2.

## Tasks to do

The lab includes the following tasks. They are described later in this guide.

1. Deploy Open5GS
2. Deploy UERANSIM
3. Create/delete UEs
4. Monitor UE sessions

## Deploy Open5GS
Here we are deploying the 5G core network. In addition, we are configuring its database to contain enough registered users (user accounts / sold SIM cards) so that we can later activate (connect/Attach) more terminals in the network without having to reconfigure the user database.

TBC

## Deploy UERANSIM
Here we are deploying the RAN network emulator. All artifacts are configured so that the RAN emulator can smoothly connect to the core network. Then we will manually change the number of active (connected) UEs (user terminals) and we will monitor their number by observing a selected metric in the core network (in fact, we will monitor the _active-sessions_ metric provided by the AMF function in the 5G core).

TBC

## Create/delete UE terminals
TBC

## Monitor active sessions
TBC
