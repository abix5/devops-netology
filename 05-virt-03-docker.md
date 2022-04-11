# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

## Задача 1

<details>
<summary>Dockerfile and push image</summary>

```dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
```

```shell
dmitriynenashev@MBP-Dmitriy-2 05-virt-03-docker % docker build -t abix/nginx-netology .
[+] Building 1.3s (7/7) FINISHED                                                          
 => [internal] load build definition from Dockerfile                                 0.5s
 => => transferring dockerfile: 36B                                                  0.0s
 => [internal] load .dockerignore                                                    0.3s
 => => transferring context: 2B                                                      0.0s
 => [internal] load metadata for docker.io/library/nginx:alpine                      0.0s
 => [internal] load build context                                                    0.2s
 => => transferring context: 31B                                                     0.0s
 => [1/2] FROM docker.io/library/nginx:alpine                                        0.0s
 => CACHED [2/2] COPY index.html /usr/share/nginx/html/index.html                    0.0s
 => exporting to image                                                               0.3s
 => => exporting layers                                                              0.0s
 => => writing image sha256:7946249c6f37b69056ba9279fff424cb03ddc1253cfa4744a5a2b37  0.0s
 => => naming to docker.io/abix/nginx-netology                                       0.0s
dmitriynenashev@MBP-Dmitriy-2 05-virt-03-docker % docker push abix/nginx-netology:latest
The push refers to repository [docker.io/abix/nginx-netology]
8cde0cba101d: Pushed 
bf3ec059f5ae: Layer already exists 
12751e857215: Layer already exists 
647712d5ea56: Layer already exists 
a0b311f5c332: Layer already exists 
b7ccafc028c4: Layer already exists 
4f4ce317c6bb: Layer already exists 
latest: digest: sha256:f43e7780659b289524f4132495b840978cb4c3743299290262ed79461a024123 size: 1775
```
</details>

https://hub.docker.com/repository/docker/abix/nginx-netology

## Задача 2

> Высоконагруженное монолитное java веб-приложение;

Ключевое слово монолитное, если бы архитектура была бы микро-сервисная, тогда думаю хорошим решением было бы использование контейнеризации. В данном случае Виртуальная машина подойдет лучше.

> Nodejs веб-приложение;

Идеально подходит именно контейнеризация приложения. Всегда одна среда запуска, простая пересборка, четкий контроль версий nodejs

> Мобильное приложение c версиями для Android и iOS;

Скорее нет. Существуют конечно проекты запуска эмуляторов и приложений для Android/iOS с использованием Docker, но пока это максимум можно использовать для тестов и какой-то простой отладки.

> Шина данных на базе Apache Kafka;

Контейнеризация. Так как Apache Kafka предусматривает горизонтальное масштабирование. В этом как раз может выручить Docker.
 
> Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;

Контейнеризация подойдёт лучше, так как он будет удобней для кластеризации: у контейнеров меньше оверхед.

> Мониторинг-стек на базе Prometheus и Grafana;
 
Конечно [подойдет](https://grafana.com/blog/2019/05/07/ask-us-anything-should-i-run-prometheus-in-a-container/). На мой взгляд самое лучшее решение именно запуск в контейнере. Разворвачивать node_exporter с Docker скорей всего не стоит, т.к. ему требуется прямой доступ к метрикам ядра.

> MongoDB, как основное хранилище данных для java-приложения;

Да, вполне подойдёт Docker. У MongoDB даже есть официальный образ на [Docker Hub](https://hub.docker.com/_/mongo) 

> Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

Виртуальная машина, не за чем использовать контейнер, конечно если есть необходимость держать его в кластере, то будет просто привычнее и удобнее инженерам, но смысла в этом я не вижу.

## Задача 3

### Запуск контейнеров

```shell
docker run -it --rm -d --name centos -v $(pwd)/data:/data centos:latest
Unable to find image 'centos:latest' locally
latest: Pulling from library/centos
52f9ef134af7: Pull complete 
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:latest
6941c93559952e6dfa07ae12cba7b816f9da6a7f5394d44aacfe7ec346e611da
dmitriynenashev@MBP-Dmitriy-2 05-virt-03-docker % docker run -it --rm -d --name debian -v $(pwd)/data:/data debian:stable
Unable to find image 'debian:stable' locally
stable: Pulling from library/debian
c52bd4023d6a: Pull complete 
Digest: sha256:bd2e4b7bdd9e439447e55eac1d485ec770be78fbaa679bee60252d8835877f1b
Status: Downloaded newer image for debian:stable
802ffea62b2146113adb7c8f68108c831953ec331a6aa9269b2060b60c5b4e66
```

### Файл из контейнера с CentOS

```shell
dmitriynenashev@MBP-Dmitriy-2 05-virt-03-docker % docker exec -it centos bash
[root@47c1c3e6407d /]# echo "Hello Netology from CentOS!" > /data/centos.txt
[root@47c1c3e6407d /]# exit
exit
```

### Файл с хоста

```shell
dmitriynenashev@MBP-Dmitriy-2 05-virt-03-docker % echo "Hellow Netology from Host" > data/host.txt
```

### Файлы в директории /data в контейнере с Debian

```shell
dmitriynenashev@MBP-Dmitriy-2 05-virt-03-docker % docker exec -it debian bash
root@129daf342bf4:/# ls -l /data/
total 8
-rw-r--r-- 1 root root 28 Apr 11 10:00 centos.txt
-rw-r--r-- 1 root root 26 Apr 11 10:01 host.txt
```
