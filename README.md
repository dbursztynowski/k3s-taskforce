# k3s-taskforce

## **Ogólnie**

* Repozytorium dla studentów SPIW/k3s-taskforce. Opisy wykorzystania podano w instrukcjach.

* Instrukcje są dostępne w formacie edytowalnym (Word) w celu ich poprawiania / komentowania przez uczestników.

* Wszelkie sugestie są mile widziane, w szególności też propozycje zadań praktycznych do wykonania - już po uruchomieniu, skonfigurowaniu i wstępnym sprawdzeniu klastra "bojem" wg obecnej wersji instrukcji.

Uwaga: niedługo dojdzie trzecia instrukcja "instalacyjna" - dot. monitorowania Prometheus/Grafana z użyciem stosu kube-prometheus.

## **Zakładane do osiągnięcia cele laborki (lista "żywa")**

* zapoznanie się z deklaratywną naturą Ansible (na tle wybitnie imperatywnych skryptów bash) - jako przykładu notacji deklaratywne do automatyzaci zadań konfiguracyjnych (part 1)
* zapoznanie się z zasadami "sieciowania" (_networking_) w klastrach kubernetes (part 2)
  * koncepcja CNI na podstawie CNI flannel
  * usługi (Service) typu ClusterIP, NodePort, LoadBalancer; ekspozycja usług HTTP poprzez obiekt IngressPolicy
  * koncepcja NetworkPolicy (reguły filtrowania ruchu na poziomie użytkowym (twórcy usługi) )
* zapoznanie się z wybranymi aspektami zarządzania zasobami i aplikacjami w klastrach Kubernetes (part 2)
  * ograniczanie swobody rozkładania podów przez Kubernetes scheduler - mechanizmy _taint_ i _tolerations_
  * inne - do wymyślenia/zaproponowania w ramach task-force (przykłady pożądanych: skalowanie poziome/pionowe, własne metryki, ... - ale w sensownym wymiarze\!)
* zapoznanie się z problematyką monitorowania usług w środowiskacch CNF (na podstawie Prometheus/Grafana) (part 3)
  * jako fragmentem szerszego obszaru "telemetry"/"observability"

Drogą do osiągnięcia tych celów jest instalacja klastra k3s "bare metal" na platformie Raspberry Pi, instalacja i konfiguracja wybranych modułów składowych klastra (MetalLB, Traefik) oraz aplikacji poziomu "observability" (Prometheus/Grafana), a także uruchamianie przykładowych "aplikacji" demonstracyjnych w celu ilustracji wybranych konceptów.

## **Co teraz mamy w katalogach**

**_instrukcje/_** - intrukcje labowe (docelowo do użycia w ramach laborki)

**_pi-cluster-install/_** - źródłowe pliki instalacyje k3s (bash, Ansible); jednym z oczekiwań (i efektów nauczania) odnośnie tej części laborki jest analiza szablnów Ansible w celu zapoznania się z ich deklaratywną naturą (na tle wybitnie ipmeratywnych skryptów bash)

**_manifests/_** - manifesty Kubernetes dla instalowanych modułów, testowanych wdrożeń (deploymentów), przykłady ćwiczeń laborkowych (na razie zajawka - to co wynika bezpośrednio z instrukcji)

**_troubleshooting.txt_** - napotkane problemy i sposób ich rozwiązania; tutaj można dopisywać swoje przypadki, które uznajemy za istotne (a kiedyś być może zorganizować to lepiej - odrębny katalog/odrębny README.md, ...)

**_shutubu.sh_** - wywołanie w trybie _ad-hoc_ komendy Ansible wyłączającej (_shutdown_) węzły klastra; po jej wywołaniu nie trzeba czekać na zakończenie pracy Ansible i w razie czego można od razu zamknąć swoją maszynę management-host (w tym przypadku Ansible zamyka klaster autonomicznie, bez kontaktowania się zwrotnie z management-host). Trzeba tylko dostosować do swojego przypadku nazwy węzłów klastra w pliku pi-cluster-install/shutdown-hosts.ini. **To jest zalecana forma wyłączania klastra - aby ograniczyć ryzyko wystąpienia uszkodzeń wskutek "twardego" odłączenia zasilania.**


