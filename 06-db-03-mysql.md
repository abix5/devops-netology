# Домашнее задание к занятию "6.3. MySQL"
## Задача 1

<details>
<summary>Раскрыть условие задачи</summary>

> Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.
> 
> Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и  восстановитесь из него.
> 
> Перейдите в управляющую консоль `mysql` внутри контейнера.
> 
> Используя команду `\h` получите список управляющих команд.
> 
> Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.
> 
> Подключитесь к восстановленной БД и получите список таблиц из этой БД.
> 
> **Приведите в ответе** количество записей с `price` > 300.
> 
> В следующих заданиях мы будем продолжать работу с данным контейнером.

</details>

#### Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

```shell
❯ docker run --rm --name my \
    -e MYSQL_DATABASE=test_db \
    -e MYSQL_ROOT_PASSWORD=netology \
    -v $PWD/backup:/media/mysql/backup \
    -v my_data:/var/lib/mysql \
    -v $PWD/config/conf.d:/etc/mysql/conf.d \
    -p 13306:3306 \
    -d mysql/mysql-server:8.0-aarch64
d8945a3185ca32771a8d09f4d2de91b3776ff636f3a9ad73ec5256886c26a14d
❯ docker exec -it my  bash
bash-4.4# cd /media/mysql/backup/ && ls
test_dump.sql
```

#### Изучите бэкап БД и  восстановитесь из него.

```shell
bash-4.4# mysql -u root -p test_db < ./test_dump.sql
```

#### Найдите команду для выдачи статуса БД и приведите в ответе из ее вывода версию сервера БД.

```shell
mysql> \s
--------------
mysql  Ver 8.0.29 for Linux on aarch64 (MySQL Community Server - GPL)

...
Server version:		8.0.29 MySQL Community Server - GPL
...
--------------
```

#### Подключитесь к восстановленной БД и получите список таблиц из этой БД. Приведите в ответе количество записей с `price` > 300.

```shell
mysql> use test_db
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> select count(*) from orders where price > 300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)
```

## Задача 2

<details>
<summary>Раскрыть условие задачи</summary>

> Создайте пользователя test в БД c паролем test-pass, используя:
> - плагин авторизации mysql_native_password
> - срок истечения пароля - 180 дней
> - количество попыток авторизации - 3
> - максимальное количество запросов в час - 100
> - аттрибуты пользователя:
>     - Фамилия "Pretty"
>     - Имя "James"
> 
> Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
> 
> Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и
> **приведите в ответе к задаче**.

</details>

### Создайте пользователя test в БД c паролем test-pass

```sql 
CREATE USER 'test'@'%' 
    IDENTIFIED WITH mysql_native_password BY 'test-pass'
    WITH MAX_CONNECTIONS_PER_HOUR 100
    PASSWORD EXPIRE INTERVAL 180 DAY
    FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 2
    ATTRIBUTE '{"first_name":"James", "last_name":"Pretty"}';
```

### Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`

```sql
grant select on test_db.* to test;
```

### Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю test
```sql
select * from INFORMATION_SCHEMA.USER_ATTRIBUTES where user = 'test';
```
| USER | HOST | ATTRIBUTE                                        |
|:-----|:-----|:-------------------------------------------------|
| test | %    | {"last\_name": "Pretty", "first\_name": "James"} |


## Задача 3

<details>
<summary>Раскрыть условие задачи</summary>

> Установите профилирование `SET profiling = 1`.
> Изучите вывод профилирования команд `SHOW PROFILES;`.
> 
> Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.
> 
> Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
> - на `MyISAM`
> - на `InnoDB`

</details>

### Исследуйте, какой engine используется в таблице БД test_db

Используется `InnoDB`

```sql
SELECT table_schema,table_name,engine FROM information_schema.tables WHERE table_schema = DATABASE();
```

| TABLE\_SCHEMA | TABLE\_NAME | ENGINE |
|:--------------|:------------|:-------|
| test\_db      | orders      | InnoDB |

```sql
set profiling = 1;
alter table orders engine = 'MyISAM';
alter table orders engine = 'InnoDB';
...
show profiles;
```

```shell
mysql> show profiles;
+----------+------------+--------------------------------------+
| Query_ID | Duration   | Query                                |
+----------+------------+--------------------------------------+
|        1 | 1.62183000 | alter table orders engine = 'InnoDB' |
|        2 | 0.76791525 | alter table orders engine = 'MyISAM' |
|        3 | 0.90800975 | alter table orders engine = 'InnoDB' |
|        4 | 1.25247100 | alter table orders engine = 'MyISAM' |
|        5 | 0.92477175 | alter table orders engine = 'InnoDB' |
|        6 | 0.71568600 | alter table orders engine = 'MyISAM' |
|        7 | 1.00791675 | alter table orders engine = 'InnoDB' |
|        8 | 0.71679450 | alter table orders engine = 'MyISAM' |
|        9 | 0.96935825 | alter table orders engine = 'InnoDB' |
|       10 | 0.69504400 | alter table orders engine = 'MyISAM' |
|       11 | 0.93305325 | alter table orders engine = 'InnoDB' |
|       12 | 0.86940325 | alter table orders engine = 'MyISAM' |
|       13 | 0.98089725 | alter table orders engine = 'InnoDB' |
|       14 | 1.69446125 | alter table orders engine = 'MyISAM' |
|       15 | 1.50420875 | alter table orders engine = 'InnoDB' |
+----------+------------+--------------------------------------+
15 rows in set, 1 warning (0.00 sec)
```

## Задача 4

<details>
<summary>Раскрыть условие задачи</summary>

> Изучите файл `my.cnf` в директории /etc/mysql.
> 
> Измените его согласно ТЗ (движок InnoDB):
> - Скорость IO важнее сохранности данных
> - Нужна компрессия таблиц для экономии места на диске
> - Размер буффера с незакомиченными транзакциями 1 Мб
> - Буффер кеширования 30% от ОЗУ
> - Размер файла логов операций 100 Мб
> 
> Приведите в ответе измененный файл `my.cnf`.

</details>

```sql
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Custom config should go here
!includedir /etc/mysql/conf.d/

# Netology
# Размер буфера кеширования 30% от размера оперативки в 8 Гб, кратный innodb_buffer_pool_chunk_size=128M
innodb_buffer_pool_size = 2560M
# Размер файла лога операций (общий размер логов равен innodb_log_file_size*2)
innodb_log_file_size = 100M
# Размер буфера для незакоммиченных транзакций
innodb_log_buffer_size = 1M
# Таблицы хранятся в отдельных файлах для компрессии таблиц
innodb_file_per_table = 1
innodb_file_format = Barracuda
# Производительность I/O операций (по умолчанию 200)
innodb_io_capacity = 1000
innodb_flush_log_at_trx_commit = 2
```