# k3s-taskforce

## **Ogólnie**

* Repozytorium dla studentów SPIW. Opisy postępowania w ramach tego labu podano w instrukcjach.

* Wykorzystujemy K3s - lekką dystrybycję Kubernetesa autorstwa Rancher. Cechuje się ona małym "footprintem", jednak przy zachowaniu pełnej funkcjonalności Kubernetes. Jest to więc rodzaj dystrybucji Kubernetesa, a nie jego okrojona wersja. Preferowanym obszarem zastosowań K3s to środowiska z ograniczoną ilością zasobów obliczeniowych (np. tzw. rozwiązania brzegowe w sieci). Nasze środowisko oparte na Raspberry Pi idealnie wpisuje się w ten scenariusz. Moduły węzła controller (master) zajmują łącznie ok. 512MB RAM, a moduły węzła worker poniżej 50MB RAM. Implementacyjne odstępstwa od "wanilla Kubernetes" polegają w szczególności na tym, że funkcje Kubernetes w ramach węzła danego typu są zaimplementowane w jednym procesie (np. moduły kubelet, kube-proxy i flanneld w węźle typu worker); w K8s poszczególne funkcje są implementowane jako niezależne pody/procesy (por. https://traefik.io/glossary/k3s-explained/). 

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

Uwaga: w przypadku korzystania z ZeroTier i jego instalacji na raspberrypi oraz zdalnym zamykaniu/startowaniu węzłów klastra należy pamiętać o niezamykaniu malinki hostującej ZeroTier (por. zt-manual.md).

**_zt-config.sh, zt-manual.md_** - skrypt i instrukcja konfiguracji sieci wirtualnej ZeroTier umożliwiającej zdalny dostęp do klastra przez wszystkich uczestników grupy studenckiej. Opisano też sposób zdalnego włączania/wyłączania klastra (włączania/wyłączania malinek).

**_troubleshooting.txt_** - napotkane problemy i sposób ich rozwiązania; tutaj opisujemy sposoby rozwiązywania problemów wszelakich, które uznajemy za warte skomentowania

## Eksperymenty gotowe do testów w ramach rozwoju własnego \[stan listy: 2023.05.17\]

**_5G Core - uruchomienie opensource 5G Core (free5GC) + symulator RAN_ (osoby zainteresowane - kontakt na priv)**
  * instalacja i sprawdzenie działania (np. ping 8.8.8.8) otwartoźródłowej platformy 5G (free5GC) w konfiguracji: (1) 5G core control plane na klastrze K3s/RaspberryPi, (2) 5G core UPF na klastrze K3s/odrębna VM/VirtualBox, (3) emulator sieci RAN (od strony 5G core, ekwiwalent UE+gNodeB) na odrębnej VM/VirtualBox
  * konkretne przykłady orkiestracyjno/management-owe na poziomie Kubernetes są do ustalenia (open-source-y nie dają się sensownie skalować horyzontalnie, najwyżej wertykalnie)

# **English version**

## **General**

* This repoo is intended for use by our SPIW students during lab experiments. All descriptions as to the what and how are contained in the guides to the lab available in the folder [instrukcje](https://github.com/dbursztynowski/k3s-taskforce/tree/master/instrukcje).

* Wykorzystujemy K3s - lekką dystrybycję Kubernetesa autorstwa Rancher. Cechuje się ona małym "footprintem", jednak przy zachowaniu pełnej funkcjonalności Kubernetes. Jest to więc rodzaj dystrybucji Kubernetesa, a nie jego okrojona wersja. Preferowanym obszarem zastosowań K3s to środowiska z ograniczoną ilością zasobów obliczeniowych (np. tzw. rozwiązania brzegowe w sieci). Nasze środowisko oparte na Raspberry Pi idealnie wpisuje się w ten scenariusz. Moduły węzła controller (master) zajmują łącznie ok. 512MB RAM, a moduły węzła worker poniżej 50MB RAM. Implementacyjne odstępstwa od "wanilla Kubernetes" polegają w szczególności na tym, że funkcje Kubernetes w ramach węzła danego typu są zaimplementowane w jednym procesie (np. moduły kubelet, kube-proxy i flanneld w węźle typu worker); w K8s poszczególne funkcje są implementowane jako niezależne pody/procesy (por. https://traefik.io/glossary/k3s-explained/). 

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

Uwaga: w przypadku korzystania z ZeroTier i jego instalacji na raspberrypi oraz zdalnym zamykaniu/startowaniu węzłów klastra należy pamiętać o niezamykaniu malinki hostującej ZeroTier (por. zt-manual.md).

**_zt-config.sh, zt-manual.md_** - skrypt i instrukcja konfiguracji sieci wirtualnej ZeroTier umożliwiającej zdalny dostęp do klastra przez wszystkich uczestników grupy studenckiej. Opisano też sposób zdalnego włączania/wyłączania klastra (włączania/wyłączania malinek).

**_troubleshooting.txt_** - napotkane problemy i sposób ich rozwiązania; tutaj opisujemy sposoby rozwiązywania problemów wszelakich, które uznajemy za warte skomentowania

## Eksperymenty gotowe do testów w ramach rozwoju własnego \[stan listy: 2023.05.17\]

**_5G Core - uruchomienie opensource 5G Core (free5GC) + symulator RAN_ (osoby zainteresowane - kontakt na priv)**
  * instalacja i sprawdzenie działania (np. ping 8.8.8.8) otwartoźródłowej platformy 5G (free5GC) w konfiguracji: (1) 5G core control plane na klastrze K3s/RaspberryPi, (2) 5G core UPF na klastrze K3s/odrębna VM/VirtualBox, (3) emulator sieci RAN (od strony 5G core, ekwiwalent UE+gNodeB) na odrębnej VM/VirtualBox
  * konkretne przykłady orkiestracyjno/management-owe na poziomie Kubernetes są do ustalenia (open-source-y nie dają się sensownie skalować horyzontalnie, najwyżej wertykalnie)

