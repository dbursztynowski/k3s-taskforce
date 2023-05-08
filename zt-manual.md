# Poradnik połączenia clustra z siecią ZeroTier (VPN)
W poradniku przedstawię sposób połączenia udostępnionego clustra z siecią ZeroTier. Umożliwi to dostęp zdalny do clustra bez konieczności otwierania czy przekierowania portów w routerach.

## Utworzenie sieci ZeroTier
1. Załóż konto na [zerotier.com](https://my.zerotier.com)
2. Po zalogowaniu, w panelu kontrolnym wybierz żółty przycisk *Create A Network*. System wygeneruje sieć i przydzieli jej nazwę. Klikając w nią, przejdziesz do ustawień sieci.

## Instalacja ZeroTier na hoście kontrolującym (management host wg instrukcji do laboratorium)
Management host to w moim przypadku VM z Ubuntu 20.04 LTS. Instalacja przebiega identycznie dla wszystkich pozostałych hostów, które np. będą łączyć się zdalnie.

1. Zainstaluj klienta sieci za pomocą polecenia
```bash
curl -s https://install.zerotier.com | sudo bash
```
2. Po zakończeniu instalacji wykonaj poniższe polecenie. ```[NETWORK-ID]``` pobierzesz ze strony z ustawieniami sieci, którą utworzyłeś wcześniej. 
```bash
sudo zerotier-cli join [NETWORK-ID]
```
3. Jeśli zobaczysz komunikat ```200 join OK``` wróć do panelu kontrolnego ZeroTier i zaakceptuj podłączenie hosta (lista *members*) zaznaczając check box po lewej stronie. System przydzieli hostowi adres IP z odpowiedniej puli (możesz zmienić ją w ustawieniach w górnej części strony).
![akceptacja połączenia hosta](https://i.ibb.co/fX02nVx/accept-connection.png "akceptacja połączenia hosta")

4. Weryfikację przydzielenia adresu IP z puli ZT można przeprowadzić, wykonując polecenie ```ip a | grep "zt"```. W moim przypadku host otrzymał IP 192.168.192.101/24.
![ip przydzielone hostowi](https://i.ibb.co/SNj1gjG/zt-ip.png "ip przydzielone hostowi")

## Zakończenie konfiguracji
Konfigurację będziemy "dopinać" na poniższym sprzęcie:
- router Linksys udostępniony do realizacji laboratorium
- management host z zainstalowanym i skonfigurowanym klientem ZeroTier
- zdalny management host, również skonfigurowany zgodnie z instrukcją
- cluster 

### Udostępnienie clustra
1. Podłączamy komputer, na którym działa management host do sieci utworzonej przez Linksys. Management host **musi** otrzymywać adres IP za pomocą zmostkowanej karty sieciowej (bridged).
2. W panelu konfiguracyjnym ZeroTier dodajemy route w karcie *Advanced -> Managed routes*. Mój Linsksys przydziela adresy z klasy 192.168.90.0/24, i taką trasę trzeba wprowadzić do ustawień ZT. 192.168.192.101 to adres management hosta, który został skonfigurowany wcześniej. Wprowadzamy route **tylko** dla hosta, który jest w jednej sieci z Linksysem.
![route do sieci linksys](https://i.ibb.co/cyM3vtf/routes.png "route do sieci linksys")
3. Kolejny krok to wprowadzenie zmian w obsłudze pakietów po stronie management hosta. Wykonaj plik ```zt-config.sh``` z tego repo na management hoście jako root. Podaj 2 argumenty - 1. nazwa interfejsu, przez który host łączy się z siecią LAN (np. eth0, enp0s1). Drugi to nazwa interfejsu sieci ZeroTier (zawsze zaczyna się od *zt*). 

### Weryfikacja połączenia
Na komputerze nieznajdującym się w twojej obecnej sieci spróbuj otworzyć stronę konfiguracyjną routera (u mnie 192.168.90.1). Możesz także pingnąć któryś z hostów jeśli są już podłączone do sieci. Jeśli połączenie nie działa sprawdź, czy ZeroTier jest aktywny (```sudo zerotier-cli info```) oraz czy zmiany wprowadzane skryptem zapisały się poprawnie (```sudo iptables -S```, powinieneś zobaczyć 2 wpisy zaczynające się od ```-A FORWARD -i```).

## That's all Folks!
Po wykonaniu skryptu management host będzie skonfigurowany do przekazywania pakietów pomiędzy interfejsami. Dzięki temu twój zespół będzie w stanie podłączyć się do clustra bez większych trudności. 

Uwaga 1: dla niektórych klientów ZT trzeba dodatkowo zaznaczyć opcję *Enable Default Route* przed podłączeniem do sieci. Inaczej dostęp nie będzie działał. 

Uwaga 2: w razie problemów z ZT – a próbował pan wyłączyć i włączyć? ;)

Uwaga 3: zmiany wprowadzone skryptem znikną po reboocie, więc w razie potrzeby wykonaj go jeszcze raz.
