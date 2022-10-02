# Домашнее задание к занятию "6.3. MySQL"

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.

### Решение задачи 1
```
 19:44:30 @ ~ []
└─ #  docker volume create mysql_data
mysql_data
 19:47:45 @ ~ []
└─ #  cd /var/lib/docker/volumes/vol_mysql/_data
 19:48:23 @ /var/lib/docker/volumes/vol_mysql/_data []
└─ #  cp ~/test_dump.sql .
 19:49:36 @ /var/lib/docker/volumes/vol_mysql/_data []
└─ #  docker run --name my_mysql -e MYSQL_ROOT_PASSWORD=mysql --rm -p 3306:3306 -v vol_mysql:/etc/mysql -d mysql:8.0
eb5c79da1a0c5700b40461a8e833727a08cfc4f538928488b523d6e80b94985e
 19:52:49 @ /var/lib/docker/volumes/vol_mysql/_data []
└─ #  docker exec -ti my_mysql bash
bash-4.4#
bash-4.4# mysql -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 17
Server version: 8.0.30 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
mysql> CREATE DATABASE test_db
    -> ;
Query OK, 1 row affected (0.00 sec)

mysql> exit
Bye
bash-4.4# mysql -p test_db < /etc/mysql/test_dump.sql
Enter password:
bash-4.4#
bash-4.4# mysql -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 19
Server version: 8.0.30 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| test_db            |
+--------------------+
5 rows in set (0.00 sec)

mysql> use test_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> \s
--------------
mysql  Ver 8.0.30 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          19
Current database:       test_db
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.30 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 21 min 36 sec

Threads: 2  Questions: 86  Slow queries: 0  Opens: 179  Flush tables: 3  Open tables: 97  Queries per second avg: 0.066
--------------

mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)

mysql> select * from orders where price > 300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.00 sec)

mysql> select count(*) from orders where price > 300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)
```
---------------------------------------------------------------------------------------------------
```
Ответы по задаче 1:
Версия сервера БД: 8.0.30 MySQL Community Server - GPL
Количество записей с `price` > 300: 1
```

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

### Решение задачи 2
```
mysql> create user 'test'@'localhost';
Query OK, 0 rows affected (0.01 sec)

mysql> alter user 'test'@'localhost'
    -> IDENTIFIED WITH mysql_native_password BY 'test-pass';
Query OK, 0 rows affected (0.00 sec)

mysql> alter user 'test'@'localhost'
    -> PASSWORD EXPIRE INTERVAL 180 DAY
    -> FAILED_LOGIN_ATTEMPTS 3;
Query OK, 0 rows affected (0.00 sec)

mysql> alter user 'test'@'localhost' WITH MAX_QUERIES_PER_HOUR 100;
Query OK, 0 rows affected (0.01 sec)

mysql> alter user 'test'@'localhost'
    -> ATTRIBUTE '{"last_name":"Pretty", "first_name":"James"}';
Query OK, 0 rows affected (0.00 sec)

mysql> grant select on test_db.orders to 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES
    -> WHERE USER='test' and HOST='localhost';
+------+-----------+------------------------------------------------+
| USER | HOST      | ATTRIBUTE                                      |
+------+-----------+------------------------------------------------+
| test | localhost | {"last_name": "Pretty", "first_name": "James"} |
+------+-----------+------------------------------------------------+
1 row in set (0.00 sec)
```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

### Решение задачи 3
```
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> SHOW PROFILES;
Empty set, 1 warning (0.00 sec)

mysql> select TABLE_SCHEMA,TABLE_NAME,TABLE_TYPE,ENGINE,VERSION,ROW_FORMAT,TABLE_ROWS 
    -> from information_schema.TABLES WHERE TABLE_SCHEMA = 'test_db';
+--------------+------------+------------+--------+---------+------------+------------+
| TABLE_SCHEMA | TABLE_NAME | TABLE_TYPE | ENGINE | VERSION | ROW_FORMAT | TABLE_ROWS |
+--------------+------------+------------+--------+---------+------------+------------+
| test_db      | orders     | BASE TABLE | InnoDB |      10 | Dynamic    |          5 |
+--------------+------------+------------+--------+---------+------------+------------+
1 row in set (0.00 sec)

mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.03 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.02 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW PROFILES;
+----------+------------+----------------------------------------+
| Query_ID | Duration   | Query                                  |
+----------+------------+----------------------------------------+
|        1 | 0.00039025 | SELECT DATABASE()                      |
|        2 | 0.00190850 | show databases                         |
|        3 | 0.00129275 | show tables                            |
|        4 | 0.02869400 | ALTER TABLE orders ENGINE = MyISAM     |
|        5 | 0.02478525 | ALTER TABLE orders ENGINE = InnoDB     |
+----------+------------+----------------------------------------+
5 rows in set, 1 warning (0.00 sec)
```
---------------------------------------------------------------------------------------------------
```
Ответы по задаче 3:
По умолчанию в таблице БД 'test_db' использовался 'engine': InnoDB
Время выполнения запроса на изменение ENGINE = MyISAM : 0.02869400 сек
Время выполнения запроса на изменение ENGINE = InnoDB : 0.02478525 сек
```

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

### Решение задачи 4
```
[mysqld]

skip-host-cache
skip-name-resolve
datadir=/var/lib/mysql
socket=/var/run/mysqld/mysqld.sock
secure-file-priv=/var/lib/mysql-files
user=mysql

pid-file=/var/run/mysqld/mysqld.pid

#Set IO Speed
innodb_flush_log_at_trx_commit = 0 

#Set compression
innodb_file_per_table = ON
innodb_compression_level = 9

#Set buffer
innodb_log_buffer_size	= 1M

#Set Buffer size
innodb_buffer_pool_size = 640M

#Set Log-file size
innodb_log_file_size = 100M

[client]
socket=/var/run/mysqld/mysqld.sock

```

