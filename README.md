# k3s-taskforce

## **Ogólnie**

* Repozytorium dla studentów SPIW/k3s-taskforce. Opisy wykorzystania podano w instrukcjach.

* Instrukcje są dostępne w formacie edytowalnym (Word) w celu ich poprawiania / komentowania przez uczestników.

* Wszelkie sugestie są mile widziane, w szególności też propozycje zadań praktycznych do wykonania - już po uruchomieniu, skonfigurowaniu i wstępnym sprawdzeniu klastra "bojem" wg obecnej wersji instrukcji.

Uwaga: niedługo dojdzie trzecia instrukcja "instalacyjna" - dot. monitorowania Prometheus/Grafana z użyciem stosu kube-prometheus.

## **Co teraz mamy w katalogach**

**_instrukcje/_** - intrukcje labowe (docelowo do użycia w ramach laborki)

**_pi-cluster-install/_** - źródłowe pliki instalacyje k3s (bash, Ansible)

**_manifests/_** - manifesty Kubernetes dla instalowanych modułów, testowanych wdrożeń (deploymentów), przykłady ćwiczeń laborkowych (na razie zajawka - to co wynika bezpośrednio z instrukcji)

**_troubleshooting.txt_** - napotkane problemy i sposób ich rozwiązania; tutaj można dopisywać swoje przypadki, które uznajemy za istotne (a kiedyś być może zorganizować to lepiej - odrębny katalog/odrębny README.md, ...)

**_shutubu.sh_** - wywołanie w trybie _ad-hoc_ komendy Ansible wyłączającej węzły klastra; po jej wywołaniu nie trzeba czekać na zakończenie pracy Ansible i w razie czego można od razu zamknąć swoją maszynę management-host (w tym przypadku Ansible zamyka klaster autonomicznie, bez kontaktowania się zwrotnie z management-host). Trzeba tylko dostosować do swojego przypadku nazwy węzłów klastra w pliku pi-cluster-install/shutdown-hosts.ini. **To jest zalecana forma wyłączania klastra - aby ograniczyć ryzyko wystąpienia uszkodzeń wskutek "twardego" odłączenia zasilania.


