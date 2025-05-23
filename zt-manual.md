# Poradnik połączenia klastra z siecią ZeroTier (VPN)
W niniejszym poradniku przedstawiamy sposób połączenia klastra z siecią ZeroTier. Umożliwi to dostęp zdalny do klastra bez konieczności otwierania czy przekierowania portów w routerach naszej fizycznej sieci.

## Uwagi ogólne
1. Poniższy opis sporządzono przy założeniu, że ZeroTier będzie zainstalowane na jednej z malinek naszego klastra. W takiej konfiguracji przynajmniej ta malinka powinna cały czas pracować. Pozostałe malinki mogą być wyłączane na czas sensownie długich przerw w pracy - dla oszczędzania malinek. Niestety, wyłączenie malinek (`shutdown`) nie zatrzymuje wentylatorów w nakładkach PoE - wentylatory te można wyłączyć jedynie odłączając zasilanie całego rutera TP-Link (w cztereh klastrach nakładka posiada mikroprzełącznik, którym można wyłączyć wentylator). Sposób zdalnego włączenia klastra podano w następnym punkcie Uwag ogólnych.
2. Gdyby instalację ZeroTier chcieć przeprowadzić na odrębnej "maszynie" (nie malince) pracującej w tej samej podsieci co nasz cluster, wtedy wystarczy "zamienić" słowo raspberka na "maszyna" i niniejsza instrukcja w 100% stosuje się do tego przypadku (w takim przypadku wyłączyć można wszystkie malinki). Wyłączenie malinek można robić ręcznie wchodząc na każdą przez ssh lub skorzystać ze skryptu shutubu.sh dostępnego na głównym folderze niniejszego repo (należy wtedy zapewnić na poziomie skryptu widoczność inventory Ansible naszego klastra).

#### UWAGA: skrypt shutubu.sh korzysta z ansible w trybie ad-hoc, a ten obecnie bazuje na pliku inventory/main.yaml. Plik ten obejmuje wszystkie malinki klastra - wszystkie są wyłączane tym skryptem.

**W przypadku zainstalowania ZeroTier na malince, do wyłączania klastra należy sporządzić odrębny plik inventory - bez raspberki hostującej ZeroTier (jej przecież nie należy wyłączać, bo musi obsługiwać VPN podczas zdalnego rebootowania TP-Link)**. Jeśli nie przewidujemy zdalnego włączania klastra przez rebootowanie TP-Link, wówczas wyłączać można wszystkie węzły klastra - z wykorzystaniem pliku inventory/main.yaml.

3. Zdalne włączenie klastra jest możliwe poprzez reboot klastrowego swicha TP-Link. Podczas rebootu odłącza on i ponownie podaje zasilanie na porty PoE, co powoduje twarde włączenie płyt Raspberry Pi. Przez przeglądarkę wchodzimy na pulpit zarządzania swicha TP-Link, a tam w zakładce System wybieramy komendę Reboot. Z powyższego widać też, dlaczego w przypadku zainstalowania ZeroTier na jednej z malinek nie można jej wyłączać - musi ona zapewnić zdalne wejście do podsieci w celu przeprowadzenia rebootu switcha. Dlatego też, gdyby chcieć zdalnie wyłączać i włączać _wszystkie_ malinki, Zero Tier musimy zainstalować na maszynie odrębnej względem klastra (ale w tej samej co klaster podsieci).

**Uwaga: Fabryczny login do TP-Link to admin, hasło jest puste**.TP-Link przy pierwszym logowaniu z fabrycznymi ustawieniami wymusza zmianę hasła na niepuste. Jeśli nie daje się użyć loginu fabrycznego oznacza to, że wcześniej ktoś ustawił już swoje hasło. W takim przypadku najlepiej jest zresetować TP-Link do ustawień fabrycznych (nacisnąć przez kilka sekund długopisem mikroprzycisk w małej dziurce na tylej ściance switcha). 

5. **WAŻNE: obecna wersja skryptu install.sh wymaga**, aby sama instalacja klastra była przeprowadzona w docelowym segmencie L2 sieci - niemożliwa jest instalacja przez VPN. Inymi słowy, maszyna management i klaster muszą pracować podczas instalacji w tym samym segmencie L2. Wynika to z tego, że narzędzie `nmap`, wykorzystywane w naszym przypadku do pobrania adresów MAC malin naszego klastra, musi mieć bezpośredni dostęp do właściwego segmentu L2 sieci. Tymczasem raspberry udostąpniające, pełniąc rolę rutera L3 rezydującego pomiędzy segmentem L2 naszego VPN a segmentem L2 klastra, uniemożliwia komunikację między tymi segmentami w warstwie L2.

## Utworzenie sieci ZeroTier
1. Załóż konto na [zerotier.com](https://my.zerotier.com)
2. Po zalogowaniu, w panelu kontrolnym wybierz żółty przycisk *Create A Network*. System wygeneruje sieć i przydzieli jej nazwę. Klikając w nią, przejdziesz do ustawień sieci.

## Instalacja ZeroTier

(Zakładamy, że hostem udostęoniającym jest jeden z workerów klastra.)

Instalacja ZeroTier przebiega identycznie dla wszystkich hostów - czy to dla hosta udostępniającego klaster przez VPN, czy to dla hostów, które będą łączyć się do klastra zdalnie przez nasz VPN, także jeśli są nimi maszyny wirtualne. Jeśli ktoś ma już wcześniej zainstalowany ZeroTier, ten krok można pominąć.

Instalację na hoście udostępniającym przeprowadzamy dla wybranej raspberrki; najlepiej wybrać jedną z pracujących jako worker (np. ostatnią z prawej). Logujemy się z poziomu management hosta poprzez ssh i przeprowadzamy instalację. 

### Uwaga dla maszyn linuksowych
(w szczególności na Raspberry hostującej VPN, a także na studenckiej maszynie zdalnej)

Należy skonfigurować dwa ustawienia w /etc/sysctl.conf:

a) ```net.ipv4.ip_forward=1            # odkomentować lub dopisać```

b) ```net.ipv4.conf.all.rp_filter=2    # odkomentować lub dopisać```

   punkt b) jest zgodny z https://docs.zerotier.com/exitnode/#a-linux-gotcha-rp_filter
   
Powyższe można zrobić ręcznie, albo powinno być to jednorazowo zrobione przez skrypt ```zt-config.sh```, co dokładniej opisano w kroku 3) punktu **Udostępnienie clustra** (por. dalej).

### Właściwa instalacja ZT i dołączanie hostów do VPN

Instalacja na każdej maszynie - czy będzie to maszyna udostępniająca (raspbbery klastra lub inna), czy też maszyna Linux fizyczna lub wirtualna, która ma pełnić rolę management host.

Choć może nie być to wymagane, zaleca się podłączenie maszyny, na której instalujemy ZT, do docelowej podsieci.
   
1. Zainstaluj klienta sieci za pomocą polecenia
```bash
curl -s https://install.zerotier.com | sudo bash
```
2. Po zakończeniu instalacji wykonaj poniższe polecenie. Identyfikator utworzonej sieci VPN ```[NETWORK-ID]``` pobierzesz ze strony z ustawieniami sieci, którą utworzyłeś wcześniej. 
```bash
sudo zerotier-cli join [NETWORK-ID]
```
3. Jeśli zobaczysz komunikat ```200 join OK``` wróć do panelu kontrolnego ZeroTier i zaakceptuj podłączenie hosta (lista *members*) zaznaczając check box po lewej stronie i następnie wciskając przycisk AUTHORIZE powyżej listy z członkami Twojego VPN. System przydzieli hostowi adres IP z odpowiedniej puli (możesz zmienić ją w ustawieniach w górnej części strony).
![akceptacja połączenia hosta](https://i.ibb.co/fX02nVx/accept-connection.png "akceptacja połączenia hosta")

4. Weryfikację przydzielenia adresu IP z puli ZT można przeprowadzić, wykonując polecenie ```ip a | grep "zt"```. W moim przypadku host otrzymał IP 192.168.192.101/24.
![ip przydzielone hostowi](https://i.ibb.co/SNj1gjG/zt-ip.png "ip przydzielone hostowi")

5. Jak widać poniżej, w moim przypadku panel hostów w GUI ZeroTier obejmuje trzech klientów. W VPN mam maszynę udostępniającą klaster (jest to małe Raspberry Pi spoza klastra), maszynę wirtualną (management host) oraz host fizyczny pracujący pod Windows, który dołączyłem "na wszelki przypadek".
![mój panel ZT](instrukcje/my-zt-members.jpg)

## Zakończenie konfiguracji
Konfigurację będziemy "dopinać" na poniższym sprzęcie:
- router Linksys udostępniony do realizacji laboratorium
- raspberry pi z zainstalowanym i skonfigurowanym klientem ZeroTier (poprzedni podpunkt)
- zdalny management host, również skonfigurowany zgodnie z instrukcją (poprzedni podpunkt)
- cluster 

### Udostępnienie clustra dla naszego management host
1. Podłączamy komputer, na którym działa nasz management host, do sieci utworzonej przez Linksys lub TOTO-Link (czyli zgodnie z Fig. 1 w instrukcji laboratoryjnej _K3s-P1-K3s-installation_).
2. Upewniamy się, że management host jest skojarzony z naszym VPN: `sudo zerotier-cli listnetworks` ; jeśli nie ma skojarzenia z naszą siecią klastra, wykonujemy `sudo zerotier-cli join [NETWORK-ID]`.
3. W panelu konfiguracyjnym ZeroTier dodajemy route w karcie *Advanced -> Managed routes*. W omawianym tu przykładzie mój Linsksys przydziela adresy z podsieci **192.168.90.0/24** i taką trasę docelową (destination) muszę wprowadzić do ustawień ZeroTier. Adres **192.168.192.101** to adres udostępniającej raspberry nadany z puli adresów **192.168.192.0/24** - naszej sieci VPN ZeroTier. Został on został skonfigurowany wcześniej - widzieliśmy go powyżej w _Weryfikacji przydzielenia adresu IP_. Pełni on rolę adresu gateway'a (_via_). Wprowadzamy route **tylko** dla hosta (tutaj: raspberry udostępniająca), który jest w jednej sieci z Linksysem. Host ten będzsie pełniłvrolę rutera między segmentem nszej siecii VPN a segmentem klastra.
![route do sieci linksys - png](instrukcje/routes.png)
4. Kolejny krok to wprowadzenie zmian w obsłudze pakietów po stronie rasppberki udostępniającej. Wykonaj na niej jako **```root```** (sudo) skrypt ```zt-config.sh``` dostępny na niniejszym repo (```zt-config.sh``` wygodnie jest przekopiować z użyciem np. MobaXterm czy komendy scp). **Przed pierwszym uruchomieniem skryptu ```zt-config.sh``` należy go wyedytować** i znaleźć oraz odkomentować w nim odpowiednie linie skomentowane jako _One shot commands_. Po skutecznym wykonaniu tego skryptu linie te należy ponownie zakomentować, aby w kolejnych wywołaniach skryptu nie powielał on tych linii niepotrzebnie (będzie wywoływany prze każdym boocie maszyny - por. dalej opis **Wykonywanie pliku konfiguracyjnego podczas uruchamiania raspberry**). Jeśli konfiguracja ZT na malince wchodzącej w skład klastra jest przeprowadzana już **po** instalacji k3s naszym Ansiblem, wówczas nie należy odkomentowywać linii z _net.ipv4.ip_forward=1_, bowiem nasz Ansible wprowadza to ustawienie na wszystkich węzłach klastra. W wywołaniu skryptu podaj 2 argumenty w tej kolejności: (1) **nazwa interfejsu**, przez który Twój host łączy się z siecią LAN (np. eth0, enp0s1), (2) **nazwa interfejsu sieci ZeroTier** (zawsze zaczyna się od _zt_, np. _ztkseyd7cq_).
5. Ostatecznie efekt jest taki, że udostępniająca raspberry pełni na poziomie naszego VPN rolę rutera przekierowującego ruch do/z naszej podsieci klastra. Uwaga: sam klaster nie należy do naszej sieci VPN, ale jest z niej osiągalny.

### Weryfikacja połączenia
Na komputerze nieznajdującym się w twojej obecnej sieci spróbuj otworzyć stronę konfiguracyjną routera (u mnie 192.168.90.1). Możesz także pingnąć któryś z hostów klastra, jeśli są już podłączone do sieci. Jeśli połączenie nie działa sprawdź, czy ZeroTier jest aktywny (```sudo zerotier-cli info```) oraz czy zmiany wprowadzane skryptem zapisały się poprawnie (```sudo iptables -S```, powinieneś zobaczyć 2 wpisy zaczynające się od ```-A FORWARD -i```).

## Automatyczne uruchamianie agenta VPN na maszynie udostępniającej

Dotychczasowa konfiguracja działa do momentu restartu rasppberki (maszyny) udostępniającej. Zmiany powinny jednak mieć trwały charakter, dlatego w tym punkcie skonfigurujemy automatyczne uruchamianie skryptu `zt-config.sh` podczas startu naszej maliny.

Pierwszy krok to skonfigurowanie pliku /etc/rc.local na następującą treść, podaj argumenty takie same jak w przypadku sekcji udostępniania clustra (sudo nano /etc/rc.local):

``` bash
#!/bin/sh
/sciezka_do_pliku/zt-config.sh interfejs interfejsZT
exit 0
```

Przykładowy wygląd pliku:

``` bash
#!/bin/sh
/home/ubuntu/zt-config.sh eth0 zt2lrujjgh
exit 0
```

Następnie zmień prawa dostępu do plików:

``` bash
sudo chmod 755 /etc/rc.local
sudo chmod 755 /sciezka_do_pliku/zt-config.sh
```

Zainicjalizuj uruchamianie serwisu rc-local podczas bootowania systemu:

``` bash
sudo systemctl start rc-local
```

Dzięki takiej konfiguracji podczas uruchamiania raspperki skrypt zostanie uruchomiony automatycznie. Możesz to sprawdzić rebootując malinkę i sprawdzając ```sudo iptables -S``` czy widoczne są dwa wpisy zaczynające się od ```-A FORWARD -i```.

## That's all Folks!
Po wykonaniu skryptu raspberry będzie skonfigurowana do przekazywania pakietów pomiędzy interfejsami. Dzięki temu twój zespół będzie w stanie podłączyć się do clustra bez większych trudności. 

Uwaga 1: dla niektórych klientów ZT trzeba dodatkowo zaznaczyć opcję *Enable Default Route* przed podłączeniem do sieci. Inaczej dostęp nie będzie działał. 

Uwaga 2: w razie problemów z ZT: a czy próbował Pan wyłączyć i włączyć? ;)
