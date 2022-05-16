# Домашнее задание к занятию "6.4. PostgreSQL"
## Задача 1

<details>
<summary>Раскрыть условие задачи</summary>

> Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
> Подключитесь к БД PostgreSQL используя `psql`.
> Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.
> **Найдите и приведите** управляющие команды для:
> - вывода списка БД
> - подключения к БД
> - вывода списка таблиц
> - вывода описания содержимого таблиц
> - выхода из psql

</details>

#### вывода списка БД

```
  \l[+]   [PATTERN]      list databases
```

#### подключения к БД

```
  \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "postgres")
```

#### вывода списка таблиц

```
  \dt[S+] [PATTERN]      list tables
```

#### вывода описания содержимого таблиц

```
  \d[S+]  NAME           describe table, view, sequence, or index
```

#### выхода из psql

```
  \q                     quit psql
```


<details><summary>Раскрыть условие задачи</summary>

> Используя `psql` создайте БД `test_database`.
>
> Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).
>
> Восстановите бэкап БД в `test_database`.
>
> Перейдите в управляющую консоль `psql` внутри контейнера.
>
> Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
>
> Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` с наибольшим средним значением размера элементов в байтах.
>
> **Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

</details>

```sql
test_db=# \dt
             List of relations
 Schema |  Name  | Type  |      Owner
--------+--------+-------+-----------------
 public | orders | table | test-admin-user
(1 row)

test_db=# ANALYZE VERBOSE orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
test_db=# SELECT attname, avg_width FROM pg_stats WHERE tablename = 'orders' order by avg_width desc limit 1;
-[ RECORD 1 ]----
 attname | avg_width
---------+-----------
 title   |        16
```

## Задача 3

<details><summary>Раскрыть условие задачи</summary>

> Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).
>
> Предложите SQL-транзакцию для проведения данной операции.
>
> Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

</details>

```sql
--
-- (шардировать на orders_1 - price>499 и orders_2 - price<=499).
--

begin;

  -- Переименовываем старую orders в orders_old
  alter table public.orders rename to orders_old;

  -- создание новой orders с партиционированием
  create table public.orders (
      like public.orders_old
      including defaults
      including constraints
      including indexes
  );
  
  -- создание новой orders_1 где price>499
  create table public.orders_1 (
      check (price>499)
  ) inherits (public.orders);

  -- создание новой orders_2 где price<=499
  create table public.orders_2 (
      check (price<=499)
  ) inherits (public.orders);

  ALTER TABLE public.orders_1 OWNER TO postgres;
  ALTER TABLE public.orders_2 OWNER TO postgres;

  create rule orders_insert_over_499 as on insert to public.orders
  where (price>499)
  do instead insert into public.orders_1 values(NEW.*);

  create rule orders_insert_499_or_less as on insert to public.orders
  where (price<=499)
  do instead insert into public.orders_2 values(NEW.*);

  -- копирование данных из старой в новую orders
  insert into public.orders (id,title,price) select id,title,price from public.orders_old;

  -- перепривязывание SEQUENCE
  alter table public.orders_old alter id drop default;
  ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;

  -- удаление старой orders
  drop table public.orders_old;

end;
```

### Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

Да, можно сделать при создании таблицы, **НО** есть нюанс: данные из бекапап не попадут в партиции, т.к. загружаются с помощью `COPY`, в таком случае `RULES` не вызываются, это описано в [документации Postgres](https://www.postgresql.org/docs/13/sql-copy.html):

> COPY FROM will invoke any triggers and check constraints on the destination table. However, it will not invoke rules.

```sql
--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

drop table public.orders cascade;

CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
);
ALTER TABLE public.orders OWNER TO postgres;

-- (шардировать на orders_1 - price>499 и orders_2 - price<=499).

create table public.orders_1 (
    check (price>499)
) inherits (public.orders);

create table public.orders_2 (
    check (price<=499)
) inherits (public.orders);

ALTER TABLE public.orders_1 OWNER TO postgres;
ALTER TABLE public.orders_2 OWNER TO postgres;

create rule orders_insert_over_499 as on insert to public.orders
where (price>499)
do instead insert into public.orders_1 values(NEW.*);

create rule orders_insert_499_or_less as on insert to public.orders
where (price<=499)
do instead insert into public.orders_2 values(NEW.*);
```

<details><summary>Раскрыть условие задачи</summary>

> Используя утилиту `pg_dump` создайте бекап БД `test_database`.
>
> Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

</details>

### Используя утилиту `pg_dump` создайте бекап БД `test_database`.

```bash
pg_dump -h localhost -U test-admin-user test_db > /media/postgresql/backup/test_db_$(date --iso-8601=m | sed 's/://g; s/+/z/g').sql
```
Файл бэкапа: [test_db_2022-05-16T0848z0000.sql](06-db-04-postgresql/test_db_2022-05-16T0848z0000.sql)

### Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

Я бы добавил свойство `UNIQUE`
```sql
--
    title character varying(80) NOT NULL UNIQUE,
--
```