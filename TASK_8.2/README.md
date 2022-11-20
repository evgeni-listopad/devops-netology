## Playbook

Playbook выполняет установку и настройку `Clickhouse` и `Vector`.

### Clickhouse
1. Выполняется установка `clickhouse`.
2. Выполняется настройка удаленных подключений к `clickhouse`.
3. Создается база данных и таблица в ней.

### Vector
1. Выполняется установка `vector`.
2. Выполняется настройка `vector` для отправки логов на сервер `clickhouse`


## Variables

В Playbook используются следующие параметры:
1. `clickhouse_version` - версия устанавливаемого `clickhouse`;
2. `vector_version` - версия устанавливаемого `vector`;
3. `clickhouse_packages` - список устанавливаемых пакетов `clickhouse`;
4. `vector_packages` - список устанавливаемых пакетов `vector`;

## Tags

1. `clickhouse` - выполняется установка и конфигурирование `clickhouse`;
2. `create_database_in_clickhouse` - создание базы данных в `clickhouse`;
3. `create_table_in_clickhouse_database` - создание таблицы в базе данных `clickhouse`;
4. `vector` - выполняется установка и конфигурирование `vector`;

Для выполнения полного конфигурирования `Clickhouse` и `Vector` теги при запуске Playbook не требуются.
