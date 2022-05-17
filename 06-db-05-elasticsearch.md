# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

<details>
<summary>Раскрыть условие задачи</summary>

> В этом задании вы потренируетесь в:
> - установке elasticsearch
> - первоначальном конфигурировании elastcisearch
> - запуске elasticsearch в docker
>
> Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и
> [документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):
>
> - составьте Dockerfile-манифест для elasticsearch
> - соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
> - запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины
>
> Требования к `elasticsearch.yml`:
> - данные `path` должны сохраняться в `/var/lib`
> - имя ноды должно быть `netology_test`
>
> В ответе приведите:
> - текст Dockerfile манифеста
> - ссылку на образ в репозитории dockerhub
> - ответ `elasticsearch` на запрос пути `/` в json виде
>
> Подсказки:
> - возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
> - при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
> - при некоторых проблемах вам поможет docker директива ulimit
> - elasticsearch в логах обычно описывает проблему и пути ее решения
>
> Далее мы будем работать с данным экземпляром elasticsearch.

</details>

### Текст Dockerfile манифеста

```Dockerfile
FROM --platform=linux/amd64 centos:7

EXPOSE 9200 9300

USER 0

COPY elastic/* ./

RUN export ES_HOME="/var/lib/elasticsearch" && \
    sha512sum -c elasticsearch-7.16.0-linux-x86_64.tar.gz.sha512 && \
    tar -xzf elasticsearch-7.16.0-linux-x86_64.tar.gz && \
    rm -f elasticsearch-7.16.0-linux-x86_64.tar.gz* && \
    mv elasticsearch-7.16.0 ${ES_HOME} && \
    useradd -m -u 1000 elasticsearch && \
    chown elasticsearch:elasticsearch -R ${ES_HOME}
COPY --chown=elasticsearch:elasticsearch config/* /var/lib/elasticsearch/config/

USER 1000

ENV ES_HOME="/var/lib/elasticsearch" \
    ES_PATH_CONF="/var/lib/elasticsearch/config"

WORKDIR ${ES_HOME}

CMD ["sh", "-c", "${ES_HOME}/bin/elasticsearch"]
```
В моем случае пришлось использовать параметр `--platform=linux/amd64` т.к. образ отказывался запускаться и правильно собираться на M1

### Ссылку на образ в репозитории dockerhub
[https://hub.docker.com/r/abix/elasticsearch-netology](https://hub.docker.com/r/abix/elasticsearch-netology)

```shell
docker run --rm -d --name elastic -p 9200:9200 -p 9300:9300 abix/elasticsearch-netology
```

### Ответ `elasticsearch` на запрос пути `/` в json виде

```json
{
    "name": "netology_test",
    "cluster_name": "elasticsearch",
    "cluster_uuid": "2YLV2MnnSHup0HvE1Hl00Q",
    "version": {
        "number": "7.16.0",
        "build_flavor": "default",
        "build_type": "tar",
        "build_hash": "6fc81662312141fe7691d7c1c91b8658ac17aa0d",
        "build_date": "2021-12-02T15:46:35.697268109Z",
        "build_snapshot": false,
        "lucene_version": "8.10.1",
        "minimum_wire_compatibility_version": "6.8.0",
        "minimum_index_compatibility_version": "6.0.0-beta1"
    },
    "tagline": "You Know, for Search"
}
```

# Задача 2

<details>
<summary>Раскрыть условие задачи</summary>
В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html)
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.
</details>

Добавляем индексы в соответствии с таблицей, выводим получившийся список.

#### Индекс 1
```json
{"settings":{"number_of_shards":1,"number_of_replicas":0}}
```
```json
{
    "acknowledged": true,
    "shards_acknowledged": true,
    "index": "ind-1"
}
```
#### Индекс 2
```json
{"settings":{"number_of_shards":2,"number_of_replicas":1}}
```
```json
{
  "acknowledged": true,
  "shards_acknowledged": true,
  "index": "ind-2"
}
```
#### Индекс 3
```json
{"settings":{"number_of_shards":4,"number_of_replicas":2}}
```
```json
{
    "acknowledged": true,
    "shards_acknowledged": true,
    "index": "ind-3"
}
```


```shell
curl -X GET "$ES_URL/_cat/indices?v"
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases xzijqseWTKySnan9E6rKUQ   1   0         41            0     38.9mb         38.9mb
green  open   ind-1            vM5D4_OKQ0qaDCtr-1OX0A   1   0          0            0       226b           226b
yellow open   ind-3            JB0KVPPVRdafCwrm_r97ag   4   2          0            0       904b           904b
yellow open   ind-2            VIgpWDi6RfS5ZdaC96EHIA   2   1          0            0       452b           452b
```

```shell
curl -X GET "$ES_URL/_cluster/health?pretty"
```
```json
{
    "cluster_name": "elasticsearch",
    "status": "yellow",
    "timed_out": false,
    "number_of_nodes": 1,
    "number_of_data_nodes": 1,
    "active_primary_shards": 10,
    "active_shards": 10,
    "relocating_shards": 0,
    "initializing_shards": 0,
    "unassigned_shards": 10,
    "delayed_unassigned_shards": 0,
    "number_of_pending_tasks": 0,
    "number_of_in_flight_fetch": 0,
    "task_max_waiting_in_queue_millis": 0,
    "active_shards_percent_as_number": 50.0
}
```
Видим, что состояние green только у первого индекса. У ind-2 и ind-3 статус yellow, что логично, т.к. в созданном ранее кластере всего одна нода с одним шардом, реплики отсутствуют.

#### Удаляем все индексы
```shell
curl -X DELETE "$ES_URL/_all"
```

# Задача 3

<details>
<summary>Раскрыть условие задачи</summary>
В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository)
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html)
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее.

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`
</details>

## Приведите в ответе запрос API и результат вызова API для создания репозитория.

`Запрос`

```shell
curl -X PUT "$ES_URL/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/var/lib/elasticsearch/snapshots",
    "compress": true
  }
}'
```
`Ответ`
```json
{
  "acknowledged" : true
}
```

## Создайте индекс test с 0 реплик и 1 шардом и приведите в ответе список индексов.

```tsv
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases xzijqseWTKySnan9E6rKUQ   1   0         41            0     38.9mb         38.9mb
green  open   test             6ttYQf7tSR-wNKGkdrbyIA   1   0          0            0       226b           226b
```
## Создайте `snapshot` состояния кластера `elasticsearch`
```json
{
    "snapshot": {
        "snapshot": "test_snapshot_1",
        "uuid": "v29dtyizTHuPrtB7kEdPCA",
        "repository": "netology_backup",
        "version_id": 7160099,
        "version": "7.16.0",
        "indices": [
            ".ds-.logs-deprecation.elasticsearch-default-2022.05.17-000001",
            "test",
            ".geoip_databases",
            ".ds-ilm-history-5-2022.05.17-000001"
        ],
        "data_streams": [
            "ilm-history-5",
            ".logs-deprecation.elasticsearch-default"
        ],
        "include_global_state": true,
        "state": "SUCCESS",
        "start_time": "2022-05-17T10:01:50.240Z",
        "start_time_in_millis": 1652781710240,
        "end_time": "2022-05-17T10:01:55.717Z",
        "end_time_in_millis": 1652781715717,
        "duration_in_millis": 5477,
        "failures": [],
        "shards": {
            "total": 4,
            "failed": 0,
            "successful": 4
        },
        "feature_states": [
            {
                "feature_name": "geoip",
                "indices": [
                    ".geoip_databases"
                ]
            }
        ]
    }
}
```
## Приведите в ответе список файлов в директории со `snapshot`ами.
```shell
[elasticsearch@c13a022e8c07 elasticsearch]$ ls -l /var/lib/elasticsearch/snapshots/
total 28
-rw-r--r-- 1 elasticsearch elasticsearch 1427 May 17 10:01 index-0
-rw-r--r-- 1 elasticsearch elasticsearch    8 May 17 10:01 index.latest
drwxr-xr-x 6 elasticsearch elasticsearch 4096 May 17 10:01 indices
-rw-r--r-- 1 elasticsearch elasticsearch 9771 May 17 10:01 meta-v29dtyizTHuPrtB7kEdPCA.dat
-rw-r--r-- 1 elasticsearch elasticsearch  457 May 17 10:01 snap-v29dtyizTHuPrtB7kEdPCA.dat
```
## Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

```shell
curl -X DELETE "$ES_URL/test"

curl -H 'Content-Type: application/json' \
-XPUT $ES_URL/test-2 -d \
'{"settings":{"number_of_shards":1,"number_of_replicas":0}}'
```
```tsv
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases xzijqseWTKySnan9E6rKUQ   1   0         41            0     38.9mb         38.9mb
green  open   test-2           aTHqtc92QBCSZ0CQ6AhVpg   1   0          0            0       226b           226b
```

## Восстановите состояние кластера `elasticsearch` из `snapshot`, созданного ранее. 

`запрос к API восстановления`, ещё потребовалось сделать запросы из [документации на выключение/включение фич](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html#delete-restore) и удалени индексов, их копировал 1 в 1

```shell
curl -X POST "$ES_URL/_snapshot/netology_backup/test_snapshot_1/_restore" -H 'Content-Type: application/json' -d'
{
  "indices": "*",
  "include_global_state": true
}
'
```
`итоговый список индексов`
```tsv
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases kUPcgxcvREm2J_cnmdM-JQ   1   0         82            0    112.2mb        112.2mb
green  open   test             OQDGCvw-SXGjNY_aSCV3nA   1   0          0            0       226b           226b

```
