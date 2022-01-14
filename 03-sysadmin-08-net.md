# Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
```
telnet route-views.routeviews.org
Username: rviews
show ip route x.x.x.x/32
show bgp x.x.x.x/32
```
**Ответ:**
<details>
<summary>Click to open</summary>
<p>

```shell
vagrant@vagrant:~$ telnet route-views.routeviews.org
Trying 128.223.51.103...
Connected to route-views.routeviews.org.
Escape character is '^]'.
C
**********************************************************************

                    RouteViews BGP Route Viewer
                    route-views.routeviews.org

 route views data is archived on http://archive.routeviews.org

 This hardware is part of a grant by the NSF.
 Please contact help@routeviews.org if you have questions, or
 if you wish to contribute your view.

 This router has views of full routing tables from several ASes.
 The list of peers is located at http://www.routeviews.org/peers
 in route-views.oregon-ix.net.txt

 NOTE: The hardware was upgraded in August 2014.  If you are seeing
 the error message, "no default Kerberos realm", you may want to
 in Mac OS X add "default unset autologin" to your ~/.telnetrc

 To login, use the username "rviews".

 **********************************************************************

User Access Verification

Username: rviews
route-views>show ip route 217.173.67.118
Routing entry for 217.173.64.0/20, supernet
  Known via "bgp 6447", distance 20, metric 0
  Tag 6939, type external
  Last update from 64.71.137.241 3w4d ago
  Routing Descriptor Blocks:
  * 64.71.137.241, from 64.71.137.241, 3w4d ago
      Route metric is 0, traffic share count is 1
      AS Hops 2
      Route tag 6939
      MPLS label: none
route-views>show bgp 217.173.67.118
BGP routing table entry for 217.173.64.0/20, version 1838926506
Paths: (23 available, best #14, table default)
  Not advertised to any peer
  Refresh Epoch 3
  3303 6939 8595
    217.192.89.50 from 217.192.89.50 (138.187.128.158)
      Origin IGP, localpref 100, valid, external
      Community: 3303:1006 3303:1021 3303:1030 3303:3067 6939:7154 6939:8233 6939:9002
      path 7FE14421A988 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  4901 6079 9002 8595
    162.250.137.254 from 162.250.137.254 (162.250.137.254)
      Origin IGP, localpref 100, valid, external
      Community: 65000:10100 65000:10300 65000:10400
      path 7FE17A195048 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  57866 9002 8595
    37.139.139.17 from 37.139.139.17 (37.139.139.17)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 9002:0 9002:64667
      path 7FE10043A0F0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  53767 174 3216 3216 3216 3216 3216 3216 3216 8595
    162.251.163.2 from 162.251.163.2 (162.251.162.3)
      Origin IGP, localpref 100, valid, external
      Community: 174:21101 174:22010 53767:5000
      path 7FE187FB96E8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3333 20764 20764 8595
    193.0.0.56 from 193.0.0.56 (193.0.0.56)
      Origin IGP, localpref 100, valid, external
      Community: 20764:1100 20764:1210 20764:1220 20764:1231 20764:1241 20764:1250 20764:1300 20764:1400 20764:1501 20764:1600 20764:1700 20764:3002 20764:3011 20764:3021
      path 7FE03BD882A0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  1351 20764 20764 8595
    132.198.255.253 from 132.198.255.253 (132.198.255.253)
      Origin IGP, localpref 100, valid, external
      path 7FE130623DA8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  20912 3257 1273 3216 8595
    212.66.96.126 from 212.66.96.126 (212.66.96.126)
      Origin IGP, localpref 100, valid, external
      Community: 3257:8070 3257:30352 3257:50001 3257:53900 3257:53902 20912:65004
      path 7FE1020E23A8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 2
  8283 3216 8595
    94.142.247.3 from 94.142.247.3 (94.142.247.3)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 3216:2001 3216:4477 8283:1 8283:101 65000:52254
      unknown transitive attribute: flag 0xE0 type 0x20 length 0x18
        value 0000 205B 0000 0000 0000 0001 0000 205B
              0000 0005 0000 0001 
      path 7FE0408A6E40 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  101 3356 3216 8595
    209.124.176.223 from 209.124.176.223 (209.124.176.223)
      Origin IGP, localpref 100, valid, external
      Community: 101:20100 101:20110 101:22100 3216:2001 3216:4477 3356:2 3356:22 3356:100 3356:123 3356:503 3356:903 3356:2067
      Extended Community: RT:101:22100
      path 7FE1229F6DE8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3356 3216 8595
    4.68.4.46 from 4.68.4.46 (4.69.184.201)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 3216:2001 3216:4477 3356:2 3356:22 3356:100 3356:123 3356:503 3356:903 3356:2067
      path 7FE0CC016A70 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3549 3356 3216 8595
    208.51.134.254 from 208.51.134.254 (67.16.168.191)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 3216:2001 3216:4477 3356:2 3356:22 3356:100 3356:123 3356:503 3356:903 3356:2067 3549:2581 3549:30840
      path 7FE113622698 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  852 3356 3216 8595
    154.11.12.212 from 154.11.12.212 (96.1.209.43)
      Origin IGP, metric 0, localpref 100, valid, external
      path 7FE126ABE028 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  20130 6939 8595
    140.192.8.16 from 140.192.8.16 (140.192.8.16)
      Origin IGP, localpref 100, valid, external
      path 7FE14DE12278 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  6939 8595
    64.71.137.241 from 64.71.137.241 (216.218.252.164)
      Origin IGP, localpref 100, valid, external, best
      unknown transitive attribute: flag 0xE0 type 0x20 length 0xC
        value 0000 21B7 0000 0777 0000 0000 
      path 7FE15BA646C8 RPKI State not found
      rx pathid: 0, tx pathid: 0x0
  Refresh Epoch 1
  2497 3216 8595
    202.232.0.2 from 202.232.0.2 (58.138.96.254)
      Origin IGP, localpref 100, valid, external
      path 7FE142AE6BB8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7660 2516 1273 3216 8595
    203.181.248.168 from 203.181.248.168 (203.181.248.168)
      Origin IGP, localpref 100, valid, external
      Community: 2516:1030 7660:9003
      path 7FE138463D80 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7018 1299 3216 8595
    12.0.1.63 from 12.0.1.63 (12.0.1.63)
      Origin IGP, localpref 100, valid, external
      Community: 7018:5000 7018:37232
      path 7FE034568CE8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  49788 12552 3216 8595
    91.218.184.60 from 91.218.184.60 (91.218.184.60)
      Origin IGP, localpref 100, valid, external
      Community: 12552:12000 12552:12100 12552:12101 12552:22000
      Extended Community: 0x43:100:1
      path 7FE178DE8048 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  1221 4637 9002 8595
    203.62.252.83 from 203.62.252.83 (203.62.252.83)
      Origin IGP, localpref 100, valid, external
      path 7FE15666CE08 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  701 1273 3216 8595
    137.39.3.55 from 137.39.3.55 (137.39.3.55)
      Origin IGP, localpref 100, valid, external
      path 7FE0AE7056A0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3257 3356 3216 8595
    89.149.178.10 from 89.149.178.10 (213.200.83.26)
      Origin IGP, metric 10, localpref 100, valid, external
      Community: 3257:8794 3257:30043 3257:50001 3257:54900 3257:54901
      path 7FE0FCED1380 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3561 3910 3356 3216 8595
    206.24.210.80 from 206.24.210.80 (206.24.210.80)
      Origin IGP, localpref 100, valid, external
      path 7FE18CFEC4E8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  19214 3257 3356 3216 8595
    208.74.64.40 from 208.74.64.40 (208.74.64.40)
      Origin IGP, localpref 100, valid, external
      Community: 3257:8108 3257:30048 3257:50002 3257:51200 3257:51203
      path 7FE12BF44188 RPKI State not found
      rx pathid: 0, tx pathid: 0

```

</p>
</details>

2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.

   **Ответ:**
   
Создаём dummy интерфейс и присваиваем ему IP адрес:
```shell
vagrant@vagrant:~$ sudo modprobe -v dummy numdummies=1
insmod /lib/modules/5.4.0-91-generic/kernel/drivers/net/dummy.ko numdummies=0 numdummies=1
vagrant@vagrant:~$ lsmod | grep dummy
dummy                  16384  0
vagrant@vagrant:~$ ip link | grep dummy
3: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
vagrant@vagrant:~$ sudo ip addr add 192.168.100.1/24 dev dummy0
vagrant@vagrant:~$ ip addr | grep dummy
3: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
    inet 192.168.100.1/24 scope global dummy0
vagrant@vagrant:~$ sudo ip link set dummy0 up
vagrant@vagrant:~$ ip addr | grep dummy0
3: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    inet 192.168.100.1/24 scope global dummy0
```

Проверяем текущие маршруты:

```shell
vagrant@vagrant:~$ ip route
default via 10.211.55.1 dev eth0 proto dhcp src 10.211.55.3 metric 100 
10.211.55.0/24 dev eth0 proto kernel scope link src 10.211.55.3 
10.211.55.1 dev eth0 proto dhcp scope link src 10.211.55.3 metric 100 
192.168.100.0/24 dev dummy0 proto kernel scope link src 192.168.100.1 
```

Добавляем статический маршрут:

```shell
vagrant@vagrant:~$ sudo ip route add 8.8.8.8 via 192.168.100.1
vagrant@vagrant:~$ sudo ip route add 10.10.0.0/16 via 192.168.100.1
vagrant@vagrant:~$ ip route
default via 10.211.55.1 dev eth0 proto dhcp src 10.211.55.3 metric 100 
8.8.8.8 via 192.168.100.1 dev dummy0 
10.10.0.0/16 via 192.168.100.1 dev dummy0 
10.211.55.0/24 dev eth0 proto kernel scope link src 10.211.55.3 
10.211.55.1 dev eth0 proto dhcp scope link src 10.211.55.3 metric 100 
192.168.100.0/24 dev dummy0 proto kernel scope link src 192.168.100.1 
```

По данным из последней команды видим, что добавлены два статических маршрута для адреса 8.8.8.8 и сети 10.10.0.0/16 через dummy интерфейс.


3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.

**Ответ:**
```shell
vagrant@vagrant:~$ sudo ss -tlpn
State      Recv-Q     Send-Q         Local Address:Port         Peer Address:Port     Process                                        
LISTEN     0          4096           127.0.0.53%lo:53                0.0.0.0:*         users:(("systemd-resolve",pid=674,fd=13))     
LISTEN     0          128                  0.0.0.0:22                0.0.0.0:*         users:(("sshd",pid=1184,fd=3))                
LISTEN     0          128                     [::]:22                   [::]:*         users:(("sshd",pid=1184,fd=4))   
```
Видим, что в данной системе прослушивается порт sshd демона порт 22, порт 53 DNS резолвера systemd-resolve.

4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?
   
**Ответ:**
```shell
vagrant@vagrant:~$ sudo ss -pua
State     Recv-Q    Send-Q           Local Address:Port           Peer Address:Port    Process                                       
UNCONN    0         0                127.0.0.53%lo:domain              0.0.0.0:*        users:(("systemd-resolve",pid=674,fd=12))    
UNCONN    0         0             10.211.55.3%eth0:bootpc              0.0.0.0:*        users:(("systemd-network",pid=672,fd=15)) 
```
127.0.0.53%lo:domain - очевидно используется DNS резолвером, 10.211.55.3%eth0:bootpc используется демоном systemd-network для получения сетевой конфигурации посредством DHCP.

5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали.
   
**Ответ:**
Конфигурация домашней сети представлена в файле MyNetwork.drawio.