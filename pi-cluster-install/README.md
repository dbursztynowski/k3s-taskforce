# Zbuduj klaster Kubernetes k3s "bare metal" na Raspberry Pi używając Ansible
## K3s Ansible Playbook
Skrypt automatycznie wykrywa urządzenia Raspberry Pi w sieci podanej jako argument skryptu na podstawie prefiksów ich adresów MAC i ustanawia z nimi połączenia ssh. Następnie instaluje na tych urządzeniach k3s.

UWAGA: Ze względu na sposób identyfikacji hostów klastra (adres MAC malinki) wymagane jest, aby podczas instalacji klastra w danej sieci nie działały inne urządzenia Raspberry Pi.

## Wymagania systemowe
Do wykonania skryptu należy mieć zainstalowany Ansible w wersji 2.4.0 lub nowszej. 
## Uruchomienie skryptu
Do uruchomienia skryptu należy uzyć poniższego polecenia w powłoce Bash
```bash
   ./install.sh <sieć>
```
Gdzie w miejscu \<sieć\> trzeba wpisać adres sieci razem z maską, np. 192.168.1.0/24. Skrypt ten, po przeprowadzeniu wstępnych konfiguracji (np. utworzenie plików w inventory Ansible czy zainstalowanie kluczy ssh w hostach klastra - por. komentarze wewnątrz skryptu), wywołuje zasadniczy playbook instalacyjny dla k3s:

```bash
   ansible-playbook -i inventory/hosts.ini install_k3s.yaml --extra-vars "network=$NETWORK"
```

(Powyżej zakładamy względną lokalizację katalogów jak w naszym repozytorium - z uwagi na ścieżki podane w skrypcie.) 

Na końcu działania skrypt ściąga z klastra plik config (na potrzeby narzędzia kubectl) i zapisuje go na maszynie management-host jako plik ~/.kube/\<unikatowa-nazwa\>, gdzie \<unikatowa-nazwa\> jest generowana automatycznie w ramach skryptu (z częścią unikatową przedstawiającą czas utworzenia pliku).
