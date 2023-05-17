# k3s-taskforce

## **Ogólnie**

* Repozytorium dla studentów SPIW/k3s-taskforce. Opisy postępowania podano w instrukcjach.

* Wszelkie sugestie są mile widziane, w szególności też propozycje zadań praktycznych do wykonania.

## **Zakładane do osiągnięcia cele laborki (lista "żywa")**

* zapoznanie się z deklaratywną naturą Ansible (na tle wybitnie imperatywnych skryptów bash) - jako przykładu notacji deklaratywnej do automatyzacji zadań konfiguracyjnych **(part 1)**
* zapoznanie się z zasadami "sieciowania" (_networking_) w klastrach kubernetes **(part 2, 3)**
  * koncepcja CNI na podstawie CNI flannel
  * usługi (Service) typu ClusterIP, NodePort, LoadBalancer; ekspozycja usług HTTP poprzez mechanizm Ingress
  * koncepcja NetworkPolicy (reguły filtrowania ruchu na poziomie użytkowym (twórcy usługi))
* zapoznanie się z wybranymi aspektami zarządzania zasobami i aplikacjami w klastrach Kubernetes **(part 2, 3)**
  * ograniczanie swobody rozkładania podów przez Kubernetes scheduler - mechanizmy _taint_ i _tolerations_
  * _inne - do wymyślenia/zaproponowania w ramach task-force (przykłady pożądanych: skalowanie poziome/pionowe, własne metryki, ... - w sensownym wymiarze, ale nie trywialne, jak zmiana 'replicas: x' w Deploymencie \!)_
* zapoznanie się z problematyką monitorowania usług w środowiskacch CNF (na podstawie Prometheus/Grafana) **(part 3)**
  * jako fragmentem szerszego obszaru "telemetry"/"observability"
  * _szczegółowe działania (poza zwykłym przeglądaniem informacji w dashboardach) pozostają do zaproponowania/opracowania_

Drogą do osiągnięcia tych celów jest instalacja klastra k3s "bare metal" na platformie Raspberry Pi, instalacja i konfiguracja wybranych modułów składowych klastra (MetalLB, Traefik) oraz aplikacji poziomu "observability" (Prometheus/Grafana), a także uruchamianie przykładowych "aplikacji" demonstracyjnych w celu ilustracji wybranych konceptów.

## **Co teraz mamy w katalogach/plikach**

**_instrukcje/_** - intrukcje labowe (docelowo do użycia w ramach laborki)

**_pi-cluster-install/_** - źródłowe pliki instalacyje k3s (bash, Ansible); jednym z oczekiwań (i efektów nauczania) odnośnie tej części laborki jest analiza szablnów Ansible w celu zapoznania się z ich deklaratywną naturą (na tle wybitnie ipmeratywnych skryptów bash)

**_manifests/_** - manifesty Kubernetes dla instalowanych modułów, testowanych wdrożeń (deploymentów), przykłady ćwiczeń laborkowych (na razie _zajawka_ - to co bezpośrednio wynika z obecnej wersji instrukcji i służy głónie poznaniu mechanizów "sieciowych" Kubernetes)

**_troubleshooting.txt_** - napotkane problemy i sposób ich rozwiązania; tutaj można dopisywać swoje przypadki, które uznajemy za istotne (a kiedyś być może zorganizować to lepiej - odrębny katalog/odrębny README.md, ...)

**_shutubu.sh_** - wywołanie w trybie _ad-hoc_ komendy Ansible wyłączającej (_shutdown_) węzły klastra; po jej wywołaniu nie trzeba czekać na zakończenie pracy Ansible i w razie czego można od razu zamknąć swoją maszynę management-host (w tym przypadku Ansible zamyka klaster autonomicznie, bez kontaktowania się zwrotnie z management-host). Trzeba tylko dostosować do swojego przypadku nazwy węzłów klastra w pliku pi-cluster-install/shutdown-hosts.ini. **To jest zalecana forma wyłączania klastra - aby ograniczyć ryzyko wystąpienia uszkodzeń wskutek "twardego" odłączenia zasilania.**

Uwaga: w przypadku korzystania z ZeroTier i jego instalacji na raspberrypi oraz zdalnym zamykaniu/startowaniu węzłów klastra należy pamiętać o niezamykaniu malinki hostującej ZeroTier (por. zt-manual.md).

**_zt-config.sh, zt-manual.md_** - skrypt i instrukcja konfiguracji sieci wirtualnej ZeroTier umożliwiającej zdalny dostęp do klastra przez wszystkich uczestników grupy studenckiej.

## Eksperymenty gotowe do testów w ramach rozwoju własnego \[stan listy: 2023.05.17\]

**_5GCore- uruchomienie opensource 5GCore (free5GC) + symulator RAN/_**
  * instalacja i sprawdzenie działanie (np. ping 8.8.8.8) otwartoźródłowej platformy 5G/LTE (free5GC) w konfiguracji: 5G control plane na klastrze K3s/RaspberryPi, UPF na klastrze K3s/odrębna VM/VirtualBox i emulator sieci RAN (UE+gNodeB) na odrębnej VM/VirtualBox
  * zadania orkiestracyjno/management-owe do ustalenia (open-source-y nie dają się sensownie skalować horyzontalnie, najwyżej wertykalnie)
