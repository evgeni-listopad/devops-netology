# Домашнее задание к занятию "6.2. SQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

### Решение задачи 1
```
 20:50:25 @ ~ []
└─ #  docker volume create pgdata
pgdata
 20:52:56 @ ~ []
└─ #  docker volume create pgbackup
pgbackup
 20:53:04 @ ~ []
└─ #  docker volume ls
DRIVER    VOLUME NAME
local     pgbackup
local     pgdata
 20:56:54 @ ~ []
└─ #  docker run --name my_postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 \
> -v pgdata:/var/lib/postgresql/data -v pgbackup:/opt -d postgres:12
b0c64fe205432806563d09111e78ed656196a8488c245359c7b1e3c1048ea4b6
 20:57:22 @ ~ []
└─ #  docker ps
CONTAINER ID   IMAGE            COMMAND                  CREATED              STATUS              PORTS                                       NAMES
b0c64fe20543   postgres:12      "docker-entrypoint.s…"   About a minute ago   Up About a minute   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   my_postgres
 20:58:46 @ ~ []
└─ #  firewall-cmd --add-port=5432/tcp --permanent
success
 20:59:43 @ ~ []
└─ #  firewall-cmd --reload
success
```

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

### Решение задачи 2
```
Использованные команды:
CREATE USER "test-admin-user";

CREATE DATABASE test_db;

CREATE TABLE orders (id integer PRIMARY KEY, наименование text, цена integer);

CREATE TABLE clients (id integer PRIMARY KEY, фамилия text, страна text,
	заказ integer, FOREIGN KEY (заказ) REFERENCES orders (Id));

GRANT ALL ON orders, clients TO "test-admin-user";

CREATE USER "test-simple-user";

GRANT SELECT ON orders, clients TO "test-simple-user";
GRANT INSERT ON orders, clients TO "test-simple-user";
GRANT UPDATE ON orders, clients TO "test-simple-user";
GRANT DELETE ON orders, clients TO "test-simple-user";
```
-----------------------------------------------------------------------------------
```
Итоговый список БД:
test_db=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)
```
-----------------------------------------------------------------------------------
```
Описание таблиц:
test_db=# \dt
          List of relations
 Schema |  Name   | Type  |  Owner
--------+---------+-------+----------
 public | clients | table | postgres
 public | orders  | table | postgres
(2 rows)
```
-----------------------------------------------------------------------------------
```
SQL-запрос для выдачи списка всех пользователей с правами над таблицами test_db:
select * from information_schema.table_privileges where table_catalog = 'test_db';

SQL-запрос для выдачи пользователей 'test-admin-user','test-simple-user' с правами над таблицами test_db:
select * from information_schema.table_privileges where table_catalog = 'test_db' 
and grantee in ('test-admin-user','test-simple-user');

SQL-запросы для выдачи пользователей 'test-admin-user','test-simple-user' (по-отдельности для наглядности) 
с правами над таблицами test_db:
select * from information_schema.table_privileges where table_catalog = 'test_db' 
and grantee = 'test-admin-user';
select * from information_schema.table_privileges where table_catalog = 'test_db' 
and grantee = 'test-simple-user';
```
-----------------------------------------------------------------------------------
```
список пользователей с правами над таблицами test_db:
test_db=# select * from information_schema.table_privileges where table_catalog = 'test_db'
and grantee = 'test-admin-user';
 grantor  |     grantee     | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy
----------+-----------------+---------------+--------------+------------+----------------+--------------+----------------
 postgres | test-admin-user | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test-admin-user | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test-admin-user | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test-admin-user | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test-admin-user | test_db       | public       | orders     | TRUNCATE       | NO           | NO
 postgres | test-admin-user | test_db       | public       | orders     | REFERENCES     | NO           | NO
 postgres | test-admin-user | test_db       | public       | orders     | TRIGGER        | NO           | NO
 postgres | test-admin-user | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test-admin-user | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test-admin-user | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test-admin-user | test_db       | public       | clients    | DELETE         | NO           | NO
 postgres | test-admin-user | test_db       | public       | clients    | TRUNCATE       | NO           | NO
 postgres | test-admin-user | test_db       | public       | clients    | REFERENCES     | NO           | NO
 postgres | test-admin-user | test_db       | public       | clients    | TRIGGER        | NO           | NO
(14 rows)
test_db=# select * from information_schema.table_privileges where table_catalog = 'test_db'
and grantee = 'test-simple-user';
 grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy
----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 postgres | test-simple-user | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test-simple-user | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test-simple-user | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | DELETE         | NO           | NO
(8 rows)
```

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

### Решение задачи 3
```
Использованные команды:
insert into orders VALUES 
(1, 'Шоколад', 10), 
(2, 'Принтер', 3000), 
(3, 'Книга', 500), 
(4, 'Монитор', 7000), 
(5, 'Гитара', 4000);
insert into clients VALUES 
(1, 'Иванов Иван Иванович', 'USA'), 
(2, 'Петров Петр Петрович', 'Canada'), 
(3, 'Иоганн Себастьян Бах', 'Japan'), 
(4, 'Ронни Джеймс Дио', 'Russia'), 
(5, 'Ritchie Blackmore', 'Russia');
select count (*) from orders;
select count (*) from clients;
```
-----------------------------------------------------------------------------------
```
Результат выполнения запросов:
test_db=# select * from orders;
 id |      наименование      | цена
----+------------------------+-------
  1 | Шоколад                |    10
  2 | Принтер                |  3000
  3 | Книга                  |   500
  4 | Монитор                |  7000
  5 | Гитара                 |  4000
(5 rows)

test_db=# select count(*) from orders;
 count
-------
     5
(1 row)

test_db=# select * from clients;
 id |                фамилия                | страна | заказ
----+---------------------------------------+--------+-------
  1 | Иванов Иван Иванович                  | USA    |
  2 | Петров Петр Петрович                  | Canada |
  3 | Иоганн Себастьян Бах                  | Japan  |
  4 | Ронни Джеймс Дио                      | Russia |
  5 | Ritchie Blackmore                     | Russia |
(5 rows)

test_db=# select count(*) from clients;
 count
-------
     5
(1 row)

test_db=#
```

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказка - используйте директиву `UPDATE`.

### Решение задачи 4
```
SQL-запросы для выполнения операций:
update  clients set заказ = 3 where id = 1;
update  clients set заказ = 4 where id = 2;
update  clients set заказ = 5 where id = 3;
-----------------------------------------------------------------------------------
SQL-запрос для выдачи всех пользователей, которые совершили заказ: 
select * from clients where заказ is not null

А также вывод данного запроса:
test_db=# select * from clients where заказ is not null;
 id |             фамилия             | страна | заказ
----+---------------------------------+--------+-------
  1 | Иванов Иван Иванович            | USA    |     3
  2 | Петров Петр Петрович            | Canada |     4
  3 | Иоганн Себастьян Бах            | Japan  |     5
(3 rows)
```

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

### Решение задачи 5
```
explain select * from clients where заказ is not null;

Получившийся результат:
test_db=# explain select * from clients where заказ is not null;
                        QUERY PLAN
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72)
   Filter: ("заказ" IS NOT NULL)
(2 rows)

Интерпретация полученных значений:

Планировщик выбрал план простого последовательного сканирования (Seq Scan). 

Числа, перечисленные в скобках (слева направо), имеют следующий смысл:

0.00 - приблизительная стоимость запуска. Это время, которое проходит, прежде чем начнётся этап вывода данных.

18.10 - приблизительная общая стоимость. Она вычисляется в предположении, что узел плана выполняется до конца, 
то есть возвращает все доступные строки. 

rows=806 - ожидаемое (прогнозное) число строк, которое должен вывести этот узел плана.

width=72 - ожидаемый (прогнозный) средний размер строк, выводимых этим узлом плана (в байтах).

Filter: ("заказ" IS NOT NULL) - тип используемого фильтра для поиска.
```

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

### Решение задачи 6
```
 22:59:20 @ ~ []
└─ #  docker exec -it my_postgres pg_dump -U postgres test_db -f /opt/backup_test_db.sql
 23:04:09 @ ~ []
└─ #  docker stop my_postgres
my_postgres
 23:05:43 @ ~ []
└─ #  docker run --name my_postgres_2 -e POSTGRES_PASSWORD=postgres -p 5432:5432 \
-v pgdata:/var/lib/postgresql/data -v pgbackup:/opt -d postgres:12
abb81d1c2772da19fb2cabfc517b7fdab5003c426d9ecffad56fdc51a352d951
 23:06:20 @ ~ []
└─ #
 23:12:00 @ ~ []
└─ #  docker exec -it my_postgres_2 psql -U postgres -d test_db -f /opt/backup_test_db.sql
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
SET
ALTER TABLE
ALTER TABLE
DETAIL:  Key (id)=(4) already exists.
CONTEXT:  COPY clients, line 1
DETAIL:  Key (id)=(1) already exists.
CONTEXT:  COPY orders, line 1
GRANT
GRANT
GRANT
GRANT

 23:14:39 @ ~ []
└─ #  docker exec -it my_postgres_2 bash
root@cf8440bacd55:/# su - postgres
postgres@cf8440bacd55:~$ psql
psql (12.12 (Debian 12.12-1.pgdg110+1))
Type "help" for help.

postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)

postgres=# \c test_db
You are now connected to database "test_db" as user "postgres".

test_db=# select * from clients;
 id |             фамилия             | страна | заказ
----+---------------------------------+--------+-------
  4 | Ронни Джеймс Дио                | Russia |
  5 | Ritchie Blackmore               | Russia |
  1 | Иванов Иван Иванович            | USA    |     3
  2 | Петров Петр Петрович            | Canada |     4
  3 | Иоганн Себастьян Бах            | Japan  |     5
(5 rows)

test_db=# select * from orders;
 id | наименование | цена
----+--------------+----------
  1 | Шоколад      |       10
  2 | Принтер      |     3000
  3 | Книга        |      500
  4 | Монитор      |     7000
  5 | Гитара       |     4000
(5 rows)

```
