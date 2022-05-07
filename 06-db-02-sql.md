# Домашнее задание к занятию "6.2. SQL"
## Задача 1

<details>
<summary>Раскрыть условие задачи</summary>

> Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.
>
> Приведите получившуюся команду или docker-compose манифест.

</details>

`docker-compose.yaml`
```yaml
version: '3.6'

volumes:
  data: {}
  backup: {}

services:

  postgres:
    image: postgres:12
    container_name: psql
    ports:
      - "0.0.0.0:5432:5432"
    volumes:
      - data:/var/lib/postgresql/data
      - backup:/media/postgresql/backup
    environment:
      POSTGRES_USER: "test-admin-user"
      POSTGRES_PASSWORD: "netology"
      POSTGRES_DB: "test_db"
    restart: always
```
Старт
```shell
docker-compose up -d
export PGPASSWORD=netology && psql -h localhost -U test-admin-user test_db
```

## Задача 2
<details>
<summary>Раскрыть условие задачи</summary>

> В БД из задачи 1:
> - создайте пользователя test-admin-user и БД test_db
> - в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
> - предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
> - создайте пользователя test-simple-user
> - предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db
>
> Таблица orders:
> - id (serial primary key)
> - наименование (string)
> - цена (integer)
>
> Таблица clients:
> - id (serial primary key)
> - фамилия (string)
> - страна проживания (string, index)
> - заказ (foreign key orders)
>
> Приведите:
> - итоговый список БД после выполнения пунктов выше,
> - описание таблиц (describe)
> - SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
> - список пользователей с правами над таблицами test_db

</details>

#### Итоговый список БД после выполнения пунктов выше,

```shell
test_db=# \l
                                             List of databases
   Name    |      Owner      | Encoding |  Collate   |   Ctype    |            Access privileges
-----------+-----------------+----------+------------+------------+-----------------------------------------
 postgres  | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-admin-user"                   +
           |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user"
 template1 | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-admin-user"                   +
           |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user"
 test_db   | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/"test-admin-user"                  +
           |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user"
(4 rows)
```

`orders`

```shell
test_db=# \d orders
                                    Table "public.orders"
 Column |          Type          | Collation | Nullable |              Default
--------+------------------------+-----------+----------+------------------------------------
 id     | integer                |           | not null | nextval('orders_id_seq'::regclass)
 item   | character varying(100) |           | not null |
 price  | integer                |           | not null |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_orders_id_fk" FOREIGN KEY (orders) REFERENCES orders(id) ON UPDATE CASCADE ON DELETE CASCADE
```

`clients`

```shell
test_db=# \d clients
                                           Table "public.clients"
        Column        |          Type          | Collation | Nullable |               Default
----------------------+------------------------+-----------+----------+-------------------------------------
 id                   | integer                |           | not null | nextval('clients_id_seq'::regclass)
 surname              | character varying(100) |           | not null |
 country_of_residence | character varying(100) |           | not null |
 orders               | integer                |           |          |
Indexes:
    "clients_pk" PRIMARY KEY, btree (id)
    "clients_country_of_residence_index" btree (country_of_residence)
Foreign-key constraints:
    "clients_orders_id_fk" FOREIGN KEY (orders) REFERENCES orders(id) ON UPDATE CASCADE ON DELETE CASCADE
```
 
#### SQL-запрос для выдачи списка пользователей с правами над таблицами test_db

```sql
SELECT
    grantee, table_name, privilege_type
FROM
    information_schema.table_privileges
WHERE
    grantee in ('test-admin-user','test-simple-user')
    and table_name in ('clients','orders')
order by 1,2,3;
```

| grantee          | table\_name | privilege\_type |
|:-----------------|:------------|:----------------|
| test-admin-user  | clients     | DELETE          |
| test-admin-user  | clients     | INSERT          |
| test-admin-user  | clients     | REFERENCES      |
| test-admin-user  | clients     | SELECT          |
| test-admin-user  | clients     | TRIGGER         |
| test-admin-user  | clients     | TRUNCATE        |
| test-admin-user  | clients     | UPDATE          |
| test-admin-user  | orders      | DELETE          |
| test-admin-user  | orders      | INSERT          |
| test-admin-user  | orders      | REFERENCES      |
| test-admin-user  | orders      | SELECT          |
| test-admin-user  | orders      | TRIGGER         |
| test-admin-user  | orders      | TRUNCATE        |
| test-admin-user  | orders      | UPDATE          |
| test-simple-user | clients     | DELETE          |
| test-simple-user | clients     | INSERT          |
| test-simple-user | clients     | SELECT          |
| test-simple-user | clients     | UPDATE          |
| test-simple-user | orders      | DELETE          |
| test-simple-user | orders      | INSERT          |
| test-simple-user | orders      | SELECT          |
| test-simple-user | orders      | UPDATE          |

## Задача 3

<details>
<summary>Раскрыть условие задачи</summary>

> Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:
>
> Таблица orders
> 
| Наименование | цена |
|--------------|------|
| Шоколад      | 10   |
| Принтер      | 3000 |
| Книга        | 500  |
| Монитор      | 7000 |
| Гитара       | 4000 |
>
> Таблица clients

| ФИО                  | Страна проживания |
|----------------------|-------------------|
| Иванов Иван Иванович | USA               |
| Петров Петр Петрович | Canada            |
| Иоганн Себастьян Бах | Japan             |
| Ронни Джеймс Дио     | Russia            |
| Ritchie Blackmore    | Russia            |

> Используя SQL синтаксис:
> - вычислите количество записей для каждой таблицы
> - приведите в ответе:
    > - запросы
    > - результаты их выполнения.

</details>

#### Используя SQL синтаксис - наполните таблицы следующими тестовыми данными

`orders`
```shell
test_db=# select * from orders;
 id |  item   | price
----+---------+-------
  1 | Шоколад |    10
  2 | Принтер |  3000
  3 | Книга   |   500
  4 | Монитор |  7000
  5 | Гитара  |  4000
(5 rows)
```
`clients`
```shell
test_db=# select * from clients;
 id |       surname        | country_of_residence | orders
----+----------------------+----------------------+--------
  1 | Иванов Иван Иванович | USA                  |
  2 | Петров Петр Петрович | Canada               |
  3 | Иоганн Себастьян Бах | Japan                |
  4 | Ронни Джеймс Дио     | Russia               |
  5 | Ritchie Blackmore    | Russia               |
(5 rows)
```

#### Вычислите количество записей для каждой таблицы

```shell
test_db=# select count(*) from orders;
 count
-------
     5
(1 row)
```

```shell
test_db=# select count(*) from clients;
 count
-------
     5
(1 row)
```

## Задача 4

<details>
<summary>Раскрыть условие задачи</summary>

> Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.
> 
> Используя foreign keys свяжите записи из таблиц, согласно таблице:
> 
| ФИО                  | Заказ   |
|----------------------|---------|
| Иванов Иван Иванович | Книга   |
| Петров Петр Петрович | Монитор |
| Иоганн Себастьян Бах | Гитара  |

> Приведите SQL-запросы для выполнения данных операций.
> 
> Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
> 
> Подсказк - используйте директиву `UPDATE`.
</details>

#### Приведите SQL-запросы для выполнения данных операций.
```sql
UPDATE public.clients SET orders = 3 WHERE id = 1;
UPDATE public.clients SET orders = 4 WHERE id = 2;
UPDATE public.clients SET orders = 5 WHERE id = 3;
```
#### Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

```shell
test_db=# SELECT c.surname, c.country_of_residence, o.item FROM clients c JOIN orders o ON c.orders = o.id;
       surname        | country_of_residence |  item
----------------------+----------------------+---------
 Иванов Иван Иванович | USA                  | Книга
 Петров Петр Петрович | Canada               | Монитор
 Иоганн Себастьян Бах | Japan                | Гитара
(3 rows)
```

## Задача 5

<details>
<summary>Раскрыть условие задачи</summary>

> Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4
(используя директиву EXPLAIN).
> 
> Приведите получившийся результат и объясните что значат полученные значения.

</details>

```shell
test_db=# explain SELECT c.surname, c.country_of_residence, o.item FROM clients c JOIN orders o ON c.orders = o.id;
                               QUERY PLAN
-------------------------------------------------------------------------
 Hash Join  (cost=17.20..29.36 rows=170 width=654)
   Hash Cond: (c.orders = o.id)
   ->  Seq Scan on clients c  (cost=0.00..11.70 rows=170 width=440)
   ->  Hash  (cost=13.20..13.20 rows=320 width=222)
         ->  Seq Scan on orders o  (cost=0.00..13.20 rows=320 width=222)
(5 rows)
```

1. Сначала будет полностью построчно прочитана таблица `orders`
2. Для неё будет создан хэш по полю `id`
3. После будет прочитана таблица `clients`,
4. Для каждой строки по полю `orders` будет проверено, соответствует ли она чему-то в кеше `orders`
    - Если ничему не соответствует - строка будет пропущена
    - Если соответствует, то на основе этой строки и всех подходящих строках хеша СУБД сформирует вывод

При запуске просто `explain`, Postgres напишет только примерный план выполнения запроса и для каждой операции предположит:
- сколько роцессорного времени уйдёт на поиск первой записи и сбор всей выборки: `cost`=`первая_запись`..`вся_выборка`
- сколько примерно будет строк: `rows`
- какой будет средняя длина строки в байтах: `width`

Postgres делает предположения на основе статистики, которую собирает периодический выполня `analyze` запросы на выборку данных из служебных таблиц.

Если запустить `explain analyze`, то запрос будет выполнен и к плану добавятся уже точные данные по времени и объёму данных.

`explain verbose` и `explain analyze verbose` то для каждой операции выборки будут написаны поля таблиц, которые в выборку попали.

## Задача 6

<details>
<summary>Раскрыть условие задачи</summary>

> Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).
> 
> Остановите контейнер с PostgreSQL (но не удаляйте volumes).
> 
> Поднимите новый пустой контейнер с PostgreSQL.
> 
> Восстановите БД test_db в новом контейнере.
> 
> Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

</details>

1. Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

```shell
❯ export PGPASSWORD=netology && pg_dumpall -h localhost -U test-admin-user > dump.sql
```
2. Остановите контейнер с PostgreSQL (но не удаляйте volumes).
```shell
❯ docker-compose stop
[+] Running 1/1
 ⠿ Container psql  Stopped
❯ docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED       STATUS                      PORTS     NAMES
15a1b3266c65   postgres:12   "docker-entrypoint.s…"   2 hours ago   Exited (0) 37 seconds ago             psql
```

3. Поднимите новый пустой контейнер с PostgreSQL.

```shell
❯ docker run --rm -d -e POSTGRES_USER=test-admin-user -e POSTGRES_PASSWORD=netology -e POSTGRES_DB=test_db -v 06-db-02-sql_backup:/media/postgresql/backup --name psql2 postgres:12
2db8a1ae3f4ce7f525241e550cc66125d641f6056cd87ebfa9c68d7ee6a115c3
❯ docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS                     PORTS      NAMES
20f2cdc5e39a   postgres:12   "docker-entrypoint.s…"   15 seconds ago   Up 12 seconds              5432/tcp   psql2
15a1b3266c65   postgres:12   "docker-entrypoint.s…"   3 hours ago      Exited (0) 5 minutes ago              psql
```

4. Восстановите БД test_db в новом контейнере.

```shell
❯ docker exec -it psql2  bash
root@2db8a1ae3f4c:/# export PGPASSWORD=netology && psql -h localhost -U test-admin-user -f $(ls -1trh /media/postgresql/backup/all_*.sql) test_db
ET
SET
SET
CREATE ROLE
ALTER ROLE
psql:/media/postgresql/backup/all_2022-05-07T1339z0000.sql:16: ERROR:  role "test-admin-user" already exists
ALTER ROLE
CREATE ROLE
ALTER ROLE
You are now connected to database "template1" as user "test-admin-user".
............. e.t.c
COPY 5
COPY 5
 setval
--------
      5
(1 row)

 setval
--------
      5
(1 row)

ALTER TABLE
ALTER TABLE
CREATE INDEX
ALTER TABLE
GRANT
GRANT
GRANT
GRANT
```