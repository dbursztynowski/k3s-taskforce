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

# English version

# Build a Kubernetes k3s "bare metal" cluster on a Raspberry Pi using Ansible

NOTE: This description is also contained in the lab guide Part 1.

## K3s Ansible Playbook
The script automatically detects Raspberry Pi devices in the network provided as an argument to the script based on their MAC address prefixes and establishes ssh connections with them. It then installs k3s on these devices.

NOTE: Due to the way of identifying the cluster hosts (MAC address of the raspberry), it is required that other Raspberry Pi devices do not work in a given network segment during the cluster installation.

## System requirements
You must have Ansible version 2.4.0 or later installed to run the script.
## Running the script
To run the script, use the following command in the Bash shell
```bash
   ./install.sh <network>
```
Where in place \<network\> you need to enter the network address together with the mask, e.g. 192.168.1.0/24. This script, after performing the initial configurations (e.g. creating files in the Ansible inventory or installing ssh keys on cluster hosts - see comments inside the script), calls the basic installation playbook for k3s:

```bash
   ansible-playbook -i inventory/hosts.ini install_k3s.yaml --extra-vars "network=$NETWORK"
```

(The above assumes the relative location of the directories as in our repository - due to the paths given in the script.)

At the end of the run, the script downloads the config file from the cluster (for kubectl) and saves it on the management-host machine as ~/.kube/\<unique-name\>, where \<unique-name\> is automatically generated and (as of this writing) represents the time when the file was created.
