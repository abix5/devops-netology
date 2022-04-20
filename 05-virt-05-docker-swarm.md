# Домашнее задание к занятию "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"

## Задача 1

<details>
<summary> </summary>

> Дайте письменые ответы на следующие вопросы:
>
> - В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
> - Какой алгоритм выбора лидера используется в Docker Swarm кластере?
> - Что такое Overlay Network?

</details>

> В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?

В режиме `replicated` приложение запускается в том количестве экземпляров, какое укажет пользователь. При этом на отдельной ноде может быть как несколько экземпляров приложения, так и не быть совсем.

В режиме `global` приложение запускается обязательно на каждой ноде и в единственном экземпляре.

> Какой алгоритм выбора лидера используется в Docker Swarm кластере?

**Алгоритм консенсуса [Raft](https://docs.docker.com/engine/swarm/raft/)**.

Хорошее объяснение [как это работает](http://thesecretlivesofdata.com/raft/)

- все `manager` ноды имеют одинаковое представление о состоянии кластера
- не менее 3-х `manager` нод необходимо для отказоустойчивости 
- количество нод обязательно нечётное, не более 7 (рекомендация из документации).
- среди `manager` нод выбирается лидер, его задача гарантировать согласованность.
- лидер отправляет keepalive пакеты с заданной периодичностью в пределах 150-300мс. Если пакеты не пришли, менеджеры начинают выборы нового лидера.
- если кластер разбит, нечётное количество нод должно гарантировать, что кластер останется консистентным, т.к. факт изменения состояния считается совершенным, если его отразило большинство нод. Если разбить кластер пополам, нечётное число гарантирует что в какой-то части кластера будет большинство нод.

> Что такое Overlay Network?

Overlay network или наложенная сеть, или оверлей — виртуальная сеть туннелей, работающая поверх физической.
Underlay — физическая сеть со стабильной конфигурацией.
Overlay — абстракция над Underlay для изоляции.

Overlay может быть например таким:
* GRE-туннель
* VXLAN
* EVPN
* L3VPN
* GENEVE
* и др.

L2 VPN сеть для связи демонов Docker между собой. В основе используется технология `vxlan`

## Задача 2


<details>
<summary> </summary>

> Создать ваш первый Docker Swarm кластер в Яндекс.Облаке
>
> Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
> ```
> docker node ls
> ```

</details>

```bash
[root@node01 centos]# docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
zwlvld4u2t632eyaqolp49o8r *   node01.netology.yc   Ready     Active         Reachable        20.10.14
sma716r69ibd1j8r8hpfwqu7c     node02.netology.yc   Ready     Active         Leader           20.10.14
k2142jtbcts44tekazqjvl1ny     node03.netology.yc   Ready     Active         Reachable        20.10.14
z2cgkq6xcx5g1pn20rxtg41yy     node04.netology.yc   Ready     Active                          20.10.14
wln3x7nlvu8zljmjse46hwclb     node05.netology.yc   Ready     Active                          20.10.14
mg93fq84wv7twptp7bk9mngbs     node06.netology.yc   Ready     Active                          20.10.14
```

## Задача 3

<details>
<summary> </summary>

> Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.
>
> Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
> ```
> docker service ls
> ```

</details>

```bash
[root@node01 centos]# docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
s319m3cq88ry   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0
w2tltt23pv8q   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
td1pbsna0gww   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest
xze3wdnpr1h5   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest
6ioj1luw7yq0   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4
y61441gfh8tv   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0
keijn1f2kv7c   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0
a505r83qwzyb   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0
```

## Задача 4 (*)

<details>
<summary> </summary>

> Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:
> ```
> # см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
> docker swarm update --autolock=true
> ```

</details>

```bash
[root@node02 centos]# docker swarm update --autolock=true
Swarm updated.
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-gr7i0KUzy/zrsuOT8SMPqMSEvjS9TcepITB48duvmlY

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.
```

```bash
[root@node02 centos]# docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
zwlvld4u2t632eyaqolp49o8r     node01.netology.yc   Ready     Active         Reachable        20.10.14
sma716r69ibd1j8r8hpfwqu7c *   node02.netology.yc   Ready     Active         Reachable        20.10.14
k2142jtbcts44tekazqjvl1ny     node03.netology.yc   Ready     Active         Leader           20.10.14
z2cgkq6xcx5g1pn20rxtg41yy     node04.netology.yc   Ready     Active                          20.10.14
wln3x7nlvu8zljmjse46hwclb     node05.netology.yc   Ready     Active                          20.10.14
mg93fq84wv7twptp7bk9mngbs     node06.netology.yc   Ready     Active                          20.10.14
[root@node02 centos]#
```

`--autolock=true` (или `init --autolock` при создании кластера) заставит вводить ключ разблокировки на `manager` ноде, чтобы она могла заново присоединиться к кластеру, если была перезапущена. Ввод ключа позволит расшифровать лог Raft и загрузить все "секреты" в память ноды (логины, пароли, TLS ключи, SSH ключи и [прочие данные](https://docs.docker.com/engine/swarm/secrets/#about-secrets))

Вероятно, это нужно, чтобы защитить кластер от несанкционированного доступа к файлам ноды. Например, если кто-то получил жесткий диск сервера или образ диска виртуальной машины с нодой, чтобы он не мог получить доступ к кластеру и нодам без пароля (=токена, ключа).