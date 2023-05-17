# Zbuduj klaster Kubernetes k3s "bare metal" na Raspberry Pi używając Ansible
## K3s Ansible Playbook
Skrypt automatycznie wykrywa urzadzenia Raspberry Pi w sieci podanej jako argument skryptu na podstawie zainstalowanego w nich systemu operacyjnego i ustanawia z nimi polaczenia ssh. Nastepnie instaluje na tych urzadzeniach k3s.
## Wymagania systemowe
Do wykonania skryptu nalezy miec zainstalowany Ansible w wersji 2.4.0 lub nowszej. 
## Uruchomienie skryptu
Do uruchomienia skryptu nalezy uzyc ponizszego polecenia w powloce Bash
```bash
   ./install.sh <sieć>
```
Gdzie w miejscu \<sieć\> trzeba wpisać adres sieci razem z maska, np. 192.168.1.0/24. Skrypt ten, po przeprowadzeniu wstępnych konfiguracji (np. utworzenie plików w inventory Ansible czy zainstalowanie kluczy ssh w hostach klastra - por. komentarze wewnątrz skryptu), wywołuje zasadniczy playbook instalacyjny dla k3s:

```bash
   ansible-playbook -i inventory/hosts.ini install_k3s.yaml --extra-vars "network=$NETWORK"
```

(Powyżej zakładamy względną lokalizację katalogów jak w naszym repozytorium - z uwagi na ścieżki podane w skrypcie.) 

Na końcu działąnia skrypt ściąga z klastra plik config (na potrzeby narzędzia kubectl) i zapisuje go na maszynie management-host jako plik ~/.kube/\<unikatowa-nazwa\>, gdzie \<unikatowa-nazwa\> jest generowana automatycznie w ramach skryptu (z częścią unikatową przedstawiającą czas utworzenia pliku).
