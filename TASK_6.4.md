# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

### Решение задачи 1
```
 16:57:30 @ ~ []
└─ #  docker volume create pgdata_13
pgdata_13
 16:58:45 @ ~ []
└─ #  docker run --name my_postgres_13 -e POSTGRES_PASSWORD=postgres -p 5433:5432 -v pgdata_13:/var/lib/postgresql/data -v pgbackup:/opt -d postgres:13
Unable to find image 'postgres:13' locally
13: Pulling from library/postgres
-----------------ВЫВОД ПРОПУЩЕН-----------------------------------
7047e4ab49b5472112febc5c064396cb7bac59be26ccb98f4eca8fd5c680b35f
 17:00:35 @ ~ []
└─ #  docker exec -it 7047e4ab49b5 bash
root@7047e4ab49b5:/# su - postgres
postgres@7047e4ab49b5:~$ psql
psql (13.8 (Debian 13.8-1.pgdg110+1))
Type "help" for help.

postgres=#
```
Вывод списка БД:
```\l[+]   [PATTERN]      list databases```
Пример использования:
```
postgres-# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)

postgres-#
postgres-# \l+
                                                                   List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   |  Size   | Tablespace |                Description
-----------+----------+----------+------------+------------+-----------------------+---------+------------+--------------------------------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                       | 7901 kB | pg_default | default administrative connection database
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +| 7753 kB | pg_default | unmodifiable empty database
           |          |          |            |            | postgres=CTc/postgres |         |            |
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +| 7753 kB | pg_default | default template for new databases
           |          |          |            |            | postgres=CTc/postgres |         |            |
(3 rows)

postgres-#
```
Подключение к БД:
```  
  \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "postgres")
```
Пример использования:
```
postgres-# \c postgres
You are now connected to database "postgres" as user "postgres".
```
Вывод списка таблиц:
```
  (options: S = show system objects, + = additional detail)
  \d[S+]                 list tables, views, and sequences
```
Пример использования:
```
postgres-# \dS
                        List of relations
   Schema   |              Name               | Type  |  Owner
------------+---------------------------------+-------+----------
 pg_catalog | pg_aggregate                    | table | postgres
 pg_catalog | pg_am                           | table | postgres
 pg_catalog | pg_amop                         | table | postgres
-----------------ВЫВОД ПРОПУЩЕН-----------------------------------
```
Вывод описания содержимого таблиц:
```
  \d[S+]  NAME           describe table, view, sequence, or index
```
Пример использования:
```
postgres-#\dS pg_database
               Table "pg_catalog.pg_database"
    Column     |   Type    | Collation | Nullable | Default
---------------+-----------+-----------+----------+---------
 oid           | oid       |           | not null |
 datname       | name      |           | not null |
 datdba        | oid       |           | not null |
 encoding      | integer   |           | not null |
 datcollate    | name      |           | not null |
 datctype      | name      |           | not null |
 datistemplate | boolean   |           | not null |
 datallowconn  | boolean   |           | not null |
 datconnlimit  | integer   |           | not null |
 datlastsysoid | oid       |           | not null |
 datfrozenxid  | xid       |           | not null |
 datminmxid    | xid       |           | not null |
 dattablespace | oid       |           | not null |
 datacl        | aclitem[] |           |          |
Indexes:
    "pg_database_datname_index" UNIQUE, btree (datname), tablespace "pg_global"
    "pg_database_oid_index" UNIQUE, btree (oid), tablespace "pg_global"
Tablespace: "pg_global"

postgres-#
```
Выход из psql:
```
  \q                     quit psql
```
Пример использования:
```
postgres-# \q
postgres@7047e4ab49b5:~$
```

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

### Решение задачи 2
```
test_database=# ANALYZE VERBOSE orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
test_database=#
test_database=# select attname from pg_stats where tablename='orders';
 attname
---------
 id
 title
 price
(3 rows)

test_database=# select avg_width from pg_stats where tablename='orders';
 avg_width
-----------
         4
        16
         4
(3 rows)
```
ОТВЕТ:
``` 
Столбец таблицы `orders` с наибольшим средним значением размера элементов в байтах - это столбец title
Среднее значение размера элементов в байтах в столбце title: 16.
```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

### Решение задачи 3
```
-----------Перед тем, как создавать транзакцию, проверим каких типов столбцы в текущей таблице orders----------
test_database=# select column_name,data_type,udt_name from information_schema.columns where table_name = 'orders';
 column_name |     data_type     | udt_name
-------------+-------------------+----------
 id          | integer           | int4
 title       | character varying | varchar
 price       | integer           | int4
(3 rows)
-----------Используемая SQL-транзакция--------------------------------------------------
test_database=# BEGIN;
BEGIN
test_database=*# ALTER TABLE orders RENAME TO orders_init;
ALTER TABLE
test_database=*# CREATE TABLE orders (id integer, title varchar(50), price integer) PARTITION BY RANGE (price);
CREATE TABLE
test_database=*# CREATE TABLE orders_1 PARTITION OF orders FOR VALUES FROM (500) TO (999999999);
CREATE TABLE
test_database=*# CREATE TABLE orders_2 PARTITION OF orders FOR VALUES FROM (0) TO (500);
CREATE TABLE
test_database=*# INSERT INTO orders (id, title, price) SELECT * FROM orders_init;
INSERT 0 8
test_database=*# COMMIT;
COMMIT
test_database=# SELECT * FROM orders_1;
 id |       title        | price
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
(3 rows)

test_database=# SELECT * FROM orders_2;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
(5 rows)

test_database=#
```
При проектировании таблицы orders можно было исключить необходимость ее последующего "ручного" разбиения.
Для этого таблицу orders можно было сделать сразу секционированной.

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

### Решение задачи 4
```
postgres@7047e4ab49b5:~/data$ pg_dump -d test_database > /var/lib/postgresql/data/test_database_dump.sql
postgres@7047e4ab49b5:~/data$
postgres@7047e4ab49b5:~/data$ ls -l /var/lib/postgresql/data/test_database_dump.sql
-rw-r--r-- 1 postgres postgres 3318 Oct  8 19:09 /var/lib/postgresql/data/test_database_dump.sql
postgres@7047e4ab49b5:~/data$
```
В соответствии с объяснением, которое было дано на вебинаре, доработка бэкап-файла заключается в том, 
что в этом файле с использованием текстового редактора необходимо скорректировать секции, отечающие за 
создание дочерних таблиц, добавив в них ключевое слово UNIQUE, следующим образом:
Было:
```
CREATE TABLE public.orders_1 (
    id integer,
    title character varying(50),
    price integer
);
-------------------------------------------------------------
CREATE TABLE public.orders_2 (
    id integer,
    title character varying(50),
    price integer
);
```
Должно быть:
```
CREATE TABLE public.orders_1 (
    id integer,
    title character varying(50) UNIQUE,
    price integer
);
-------------------------------------------------------------
CREATE TABLE public.orders_2 (
    id integer,
    title character varying(50) UNIQUE,
    price integer
);
```
В таком случае восстановление происходит корректно, а попытка добавить запись с уже существующим значением title 
приводит к ошибке, что свидетельствует о корректном применении ключевого слова UNIQUE.
```
postgres@7047e4ab49b5:~/data$ psql -f ./test_database_dump.sql test_database
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
SET
CREATE TABLE
ALTER TABLE
ALTER TABLE
CREATE TABLE
ALTER TABLE
ALTER TABLE
CREATE TABLE
ALTER TABLE
COPY 3
COPY 5
postgres@7047e4ab49b5:~/data$ psql
psql (13.8 (Debian 13.8-1.pgdg110+1))
Type "help" for help.

postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=#
test_database=# INSERT INTO orders (id, title, price) VALUES (9, 'War and peace', 200);
ERROR:  duplicate key value violates unique constraint "orders_2_title_key"
DETAIL:  Key (title)=(War and peace) already exists.
test_database=#
```


