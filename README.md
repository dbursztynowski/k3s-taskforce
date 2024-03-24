# k3s-taskforce

## **Ogólnie**

* Repozytorium dla studentów SPIW. Opisy postępowania w ramach tego labu podano w instrukcjach.

* Wykorzystujemy K3s - lekką dystrybycję Kubernetesa autorstwa Rancher. Cechuje się ona małym "footprintem", jednak przy zachowaniu pełnej funkcjonalności Kubernetes. Jest to więc rodzaj dystrybucji Kubernetesa, a nie jego okrojona wersja. Preferowanym obszarem zastosowań K3s to środowiska z ograniczoną ilością zasobów obliczeniowych (np. tzw. rozwiązania brzegowe w sieci). Nasze środowisko oparte na Raspberry Pi idealnie wpisuje się w ten scenariusz. Moduły węzła controller (master) zajmują łącznie ok. 512MB RAM, a moduły węzła worker poniżej 50MB RAM. Implementacyjne odstępstwa od "vanilla Kubernetes" polegają w szczególności na tym, że funkcje Kubernetes w ramach węzła danego typu są zaimplementowane w jednym procesie (np. moduły kubelet, kube-proxy i flanneld w węźle typu worker); w K8s poszczególne funkcje są implementowane jako niezależne pody/procesy (por. https://traefik.io/glossary/k3s-explained/). 

* Wszelkie sugestie są mile widziane, w szególności też propozycje zadań praktycznych do wykonania.

## **Zakładane do osiągnięcia cele laborki (lista "żywa")**

* zapoznanie się z deklaratywną naturą Ansible (na tle wybitnie imperatywnych skryptów bash) - jako przykładu notacji deklaratywnej do automatyzacji zadań konfiguracyjnych **(part 1)**
* zapoznanie się z zasadami "sieciowania" (_networking_) w klastrach kubernetes **(part 2, 3)**
  * koncepcja CNI na podstawie CNI flannel
  * usługi (Service) typu ClusterIP, NodePort, LoadBalancer; ekspozycja usług HTTP poprzez mechanizm Ingress
  * koncepcja NetworkPolicy (reguły filtrowania ruchu na poziomie użytkowym (twórcy usługi))
* zapoznanie się z wybranymi aspektami zarządzania zasobami i aplikacjami w klastrach Kubernetes **(part 2, 3)**
  * ograniczanie swobody rozkładania podów przez Kubernetes scheduler - mechanizmy _taint_ i _tolerations_
  * _inne - do wymyślenia/zaproponowania w ramach task-force (przykłady pożądanych: skalowanie poziome/pionowe, własne metryki, ... - w sensownym wymiarze, ale niekoniecznie tak proste, jak zmiana 'replicas: x' w Deploymencie \!)_
* zapoznanie się z problematyką monitorowania usług w środowiskacch CNF (na podstawie Prometheus/Grafana) **(part 3)**
  * jako fragmentem szerszego obszaru "telemetry"/"observability"
  * _szczegółowe działania (poza przeglądaniem w dashboardach informacji na temat stanu samego klastra) pozostają do zaproponowania/opracowania_

Drogą do osiągnięcia tych celów jest instalacja klastra k3s "bare metal" na platformie Raspberry Pi, instalacja i konfiguracja wybranych modułów składowych klastra (MetalLB, Traefik) oraz aplikacji poziomu "observability" (Prometheus/Grafana) z wykorzystaniem różnych mechanizmów/funkcjonalności Kubernetes, a także uruchamianie przykładowych "aplikacji" demonstracyjnych w celu ilustracji wybranych konceptów.

## **Co teraz mamy w katalogach/plikach**

**_ansible-tests/_** - proste przykłady ansible; obecnie: mikro-demo ilustrujące istotę działania "gather facts" na przykładzie lokalnego hosta

**_instrukcje/_** - intrukcje labowe (docelowo do użycia w ramach laborki)

**_pi-cluster-install/_** - źródłowe pliki instalacyje k3s (bash, Ansible); jednym z oczekiwań (i efektów nauczania) odnośnie tej części laborki jest analiza szablnów Ansible w celu zapoznania się z ich deklaratywną naturą (na tle wybitnie ipmeratywnych skryptów bash)

**_manifests/_** - manifesty Kubernetes dla instalowanych modułów, testowanych wdrożeń (deploymentów), przykłady ćwiczeń laborkowych (na razie _zajawka_ - to co bezpośrednio wynika z obecnej wersji instrukcji i służy głównie poznaniu mechanizów "sieciowych" Kubernetes)

**_shutubu.sh_** - wywołanie w trybie _ad-hoc_ komendy Ansible wyłączającej (_shutdown_) węzły klastra; po jej wywołaniu nie trzeba czekać na zakończenie pracy Ansible i w razie czego można od razu zamknąć swoją maszynę management-host (w tym przypadku Ansible zamyka klaster autonomicznie, bez kontaktowania się zwrotnie z management-host). Trzeba tylko dostosować do swojego przypadku nazwy węzłów klastra w pliku pi-cluster-install/shutdown-hosts.ini. **To jest zalecana forma wyłączania klastra - aby ograniczyć ryzyko wystąpienia uszkodzeń wskutek "twardego" odłączenia zasilania.** Na końcu pliku w komentarzu podano też sposób odczytywania temperatury CPU malinki z wiersza poleceń.

Uwaga: w przypadku korzystania z ZeroTier i jego instalacji na raspberrypi oraz zdalnym zamykaniu/startowaniu węzłów klastra należy pamiętać o niezamykaniu malinki hostującej ZeroTier (por. zt-manual.md). W przypadku zainstalowania ZeroTier (lub podobnej aplikacji) na odrębnej maszynie cały klaster może zostać zamknięty. W przypadku problemów z siecią na terenie akademików PW (niestety, zdarza się z powodu stosowanych polityk bezpieczeństwa) należy interweniować u administratora sieci lokalnej.

**_zt-config.sh, zt-manual.md_** - skrypt i instrukcja konfiguracji sieci wirtualnej ZeroTier umożliwiającej zdalny dostęp do klastra przez wszystkich uczestników grupy studenckiej. Opisano też sposób zdalnego włączania/wyłączania klastra (włączania/wyłączania malinek).

**_troubleshooting.txt_** - napotkane problemy i sposób ich rozwiązania; tutaj opisujemy sposoby rozwiązywania problemów wszelakich, które uznajemy za warte skomentowania

## Eksperymenty gotowe do testów w ramach rozwoju własnego \[stan listy: 2023.05.17\]

**_5G Core - uruchomienie opensource 5G Core (free5GC) + symulator RAN_ (osoby zainteresowane - kontakt na priv)**
  * instalacja i sprawdzenie działania (np. ping 8.8.8.8) otwartoźródłowej platformy 5G (free5GC) w konfiguracji: (1) 5G core control plane na klastrze K3s/RaspberryPi, (2) 5G core UPF na klastrze K3s/odrębna VM/VirtualBox, (3) emulator sieci RAN (od strony 5G core, ekwiwalent UE+gNodeB) na odrębnej VM/VirtualBox
  * konkretne przykłady orkiestracyjno/management-owe na poziomie Kubernetes są do ustalenia (open-source-y nie dają się sensownie skalować horyzontalnie, najwyżej wertykalnie)

# **English version**

## **General**

* This repo is intended for use by our SPIW students during their lab experiments. All descriptions as to the _what and how_ are contained in the guides to the lab available in the folder [instrukcje](https://github.com/dbursztynowski/k3s-taskforce/tree/master/instrukcje).

* We use K3s - a lightweight Kubernetes distribution by Rancher. It is characterized by a small "footprint", while maintaining full Kubernetes functionality. So this is a kind of Kubernetes distribution, not a stripped down version of it. The preferred area of application of K3s are environments with a limited amount of computing resources (e.g. so-called edge solutions in the network). Our Raspberry Pi-based environment fits perfectly into this scenario. The controller (master) node modules occupy a total of approximately 512MB RAM, and the worker node modules require less than 50MB RAM. Implementation bias from "vanilla Kubernetes" consists in particular in that Kubernetes functions on nodes of a given type (master/worker) in a k3 cluster are implemented in a single process (e.g., kubelet, kube-proxy and flanneld modules in worker nodes are implemented in one process); while in K8s, individual functions are implemented as independent pods/processes (ref. https://traefik.io/glossary/k3s-explained/). 

* All suggestions to improve the lab are wellcome, in particular propositions of new experiments.

## **Assumed goals of the laboratory to be achieved ("live" list)**

* getting acquainted with the declarative nature of Ansible (in contrast to highly imperative bash scripts that also are used in the lab) - as an example of a declarative notation used for the automation of configuration tasks **(part 1 of the lab)**
* principles of kubernetes networking **(part 2, 3 of the lab)**
  * the role of CNI based on flannel CNI
  * Services: ClusterIP, NodePort, LoadBalancer; exposing HTTP services using Ingress
  * NetworkPolicy - rules for user traffic filtering within the cluster
* getting acquainted with selected aspects of resource and application management in Kubernetes clusters **(part 2, 3 of the lab)**
  * controlling the placement of pods by Kubernetes scheduler - _taint_ and _tolerations_ mechanisms
  * _other use cases are welcome - to be invented/proposed by the students (examples: horizontal/vertical scaling, custom metrics, etc., however, tailored to a reasonable "size", still not as simple as changing 'replicas: x' in Deployment \!)_
* getting acquainted with service monitoring in CNF environments (based on Prometheus/Grafana) **(part 3 of the lab)**
  * as part of a wider domain referred to as "telemetry"/"observability"
  * _apart form installation and very basic operations (viewing information about the state of the cluster in Grafana dashboards), more complex/interesting use cases remain to be prepared and propositions are more than welcome_

The means to achieve these goals is the installation of k3s "bare metal" cluster on Raspberry Pi platform, the installation and configuration of selected cluster components (MetalLB, Traefik) and "observability" level applications (Prometheus/Grafana) using various Kubernetes mechanisms/functionalities, and also running simple demo "applications" to illustrate selected concepts.

## **What we have in the folders/files**

**_ansible-tests/_** - simple examples of Ansible constructs; currently: micro-demo illustrating the essence of "gather facts" based on the example of a local host

**_instrukcje/_** - lab guides (the main part of the lab)

**_pi-cluster-install/_** - k3s installation source files (bash, Ansible); one of the goals expected from running this part of the lab is to analyze the Ansible templates in order to get acquainted with the principles of declarative approach to task automation. Note: This will be further extended based on Kubernetes manifest examples and later on (in other labs) based on OpenStack HOT).

**_manifests/_** - Kubernetes manifests for the modules installed during the lab, tested implementations (deployments), examples of lab exercises (for now, a simple _teaser_ that strictly corresponds to the current version of the lab guides and is mainly related to learning Kubernetes networking mechanisms)

**_shutubu.sh_** - executes Ansible _ad-hoc_ command to shutdown the cluster nodes; after invoking _shutubu.sh_, you don't have to wait for Ansible to finish its work, and you can immediately shut down your management host (in this case, Ansible shuts down the cluster autonomously, without contacting back the management host). To use it one only needs to customize the cluster node names in the pi-cluster-install/shutdown-hosts.ini file. **NOTE: This is the recommended (required) form of shutting down the cluster - to reduce the risk of damage caused by a "hard" disconnection of the power supply.** Notice that at the end of the file (in a comment) inctructions to read the raspberry CPU temperature from the command line are also provided (say, a bonus :-) ).

Note: when using ZeroTier and installing it on a Raspberry Pi, and remotely shutting down/starting the cluster nodes, remember not to close the ZeroTier hosting raspberry (cf. zt-manual.md). (This note is very specifc to the SPIW lab where students of lab teams can set remote access to their cluster to have more flexibility in experimenting).

**_zt-config.sh, zt-manual.md_** - script and instructions for configuring the ZeroTier virtual network enabling remote access to the cluster by all members of a lab team. It also describes how to remotely enable/disable the cluster (enable/disable the Pis).

**_troubleshooting.txt_** - descriptions of problems encountered and hints how to solve them; here we describe the ways to solve all kinds of problems that we consider worth mentioning

## Experiments ready (or almost ready) for testing as part of self-learning \[state of the list: 2023.05.17\]

**_5G Core - deploying 5G Core (free5GC) platform + RAN network simulator_ (interested persons - please contact me on priv)**
  * installation and basic tests (e.g. ping 8.8.8.8) of the open source 5G platform (free5GC) in the following configuration: (1) 5G core control plane on the K3s/RaspberryPi cluster, (2) 5G core UPF on the K3s/separate VM/VirtualBox cluster, ( 3) RAN network emulator (equivalent of 5G-radio-network + UE + gNodeB) on a separate VM/VirtualBox
  * specific orchestration/management examples applicable at the Kubernetes level are still to be determined (for example, we know that open-source 5G platforms do not scale horizontally well, and at most a form of vertical scaling of the functions can be attempted)

