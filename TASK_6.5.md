# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [elasticsearch:7](https://hub.docker.com/_/elasticsearch) как базовый:

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib` 
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения
- обратите внимание на настройки безопасности такие как `xpack.security.enabled` 
- если докер образ не запускается и падает с ошибкой 137 в этом случае может помочь настройка `-e ES_HEAP_SIZE`
- при настройке `path` возможно потребуется настройка прав доступа на директорию

Далее мы будем работать с данным экземпляром elasticsearch.

### Решение задачи 1
- Скачиваем с hub.docker.com и запускаем образ [elasticsearch:7.17.6](https://hub.docker.com/layers/library/elasticsearch/7.17.6/images/sha256-46584db983c753d7ea74169eeffa83eefef54e49c4bfeb63b2ee243f3a3ec690?context=explore), так как образ elasticsearch:7 не был найден. Копируем из контейнера файл elasticsearch.yml для дальнейшего редактирования.
```
 00:27:44 @ ~ []
└─ #  docker pull elasticsearch:7.17.6
7.17.6: Pulling from library/elasticsearch
3b65ec22a9e9: Pull complete
8aa839ec4bcf: Pull complete
d59e7399c065: Pull complete
aaa821b5c79a: Pull complete
6b43de0011f5: Pull complete
d0e32e747aea: Pull complete
9df7bf99d869: Pull complete
6c29c988ba57: Pull complete
c547bc2077a7: Pull complete
Digest: sha256:6c128de5d01c0c130a806022d6bd99b3e4c27a9af5bfc33b6b81861ae117d028
Status: Downloaded newer image for elasticsearch:7.17.6
docker.io/library/elasticsearch:7.17.6
 18:25:31 @ ~ []
└─ #  docker run -d --name elasticsearch -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch:7.17.6
553f976f391bb6a382983998957a9ea0bc190797cbe9e4e3907a1ac07dc810e4
 18:44:02 @ ~ []
└─ #  docker container cp elasticsearch:/usr/share/elasticsearch/config/elasticsearch.yml ~/netology/my_elasticsearch.yml   
```
- Редактируем файл my_elasticsearch.yml, добиваясь следующего содержимого:
```
 19:13:40 @ ~/netology [virt-9]
└─ #  cat my_elasticsearch.yml
cluster.name: "netology_test"
path.data: /var/lib/elasticsearch/data
network.host: 0.0.0.0
```
- Готовим Dockerfile:
```
 19:22:39 @ ~/netology/elasticsearch [virt-9]
└─ #  cat Dockerfile
FROM elasticsearch:7.17.6
COPY --chown=elasticsearch:elasticsearch ./my_elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml
RUN mkdir -p /var/lib/elasticsearch/data
RUN chown -R elasticsearch /var/lib/elasticsearch
 19:22:45 @ ~/netology/elasticsearch [virt-9]
└─ #  
```
- Выполняем сборку образа:
```
docker build -t evgenilistopad/elasticsearch:7.17.6 .
Sending build context to Docker daemon  3.584kB
Step 1/4 : FROM elasticsearch:7.17.6
 ---> 5fad10241ffd
Step 2/4 : COPY --chown=elasticsearch:elasticsearch ./my_elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml
 ---> 4d53dc812afb
Step 3/4 : RUN mkdir -p /var/lib/elasticsearch/data
 ---> Running in d4c4f24b952a
Removing intermediate container d4c4f24b952a
 ---> 9b8801549899
Step 4/4 : RUN chown -R elasticsearch /var/lib/elasticsearch
 ---> Running in 2d7f1d508076
Removing intermediate container 2d7f1d508076
 ---> 2a0710218928
Successfully built 2a0710218928
Successfully tagged evgenilistopad/elasticsearch:7.17.6
 19:24:39 @ ~/netology/elasticsearch [virt-9]
└─ #
``` 
- Запустим контейнер из созданного образа:
``` 
 19:27:31 @ ~/netology/elasticsearch [virt-9]
└─ #  docker run -d --rm --name my_elasticsearch -v /opt/elasticsearch/data:/var/lib/elasticsearch/data -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" evgenilistopad/elasticsearch:7.17.6
f9efff25732368f4ba0b5c2c8c4a3494bb55d697fed1061edaece8932464c5f2
 19:29:07 @ ~/netology/elasticsearch [virt-9]
└─ #  docker ps
CONTAINER ID   IMAGE                                 COMMAND                  CREATED         STATUS         PORTS                                                                                  NAMES
f9efff257323   evgenilistopad/elasticsearch:7.17.6   "/bin/tini -- /usr/l…"   8 seconds ago   Up 7 seconds   0.0.0.0:9200->9200/tcp, :::9200->9200/tcp, 0.0.0.0:9300->9300/tcp, :::9300->9300/tcp   my_elasticsearch
 19:29:15 @ ~/netology/elasticsearch [virt-9]
└─ # 
``` 
- Проверяем ответ `elasticsearch` на запрос пути `/` в json виде:
```
 19:30:57 @ ~/netology/elasticsearch [virt-9]
└─ #  curl localhost:9200/
{
  "name" : "f9efff257323",
  "cluster_name" : "netology_test",
  "cluster_uuid" : "T6QFil2eQ3ijmEPMow-sDw",
  "version" : {
    "number" : "7.17.6",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "f65e9d338dc1d07b642e14a27f338990148ee5b6",
    "build_date" : "2022-08-23T11:08:48.893373482Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
 19:31:10 @ ~/netology/elasticsearch [virt-9]
└─ #
```
- Загружаем созданный образ в репозиторий dockerhub:
```
 19:36:30 @ ~/netology/elasticsearch [virt-9]
└─ #  docker login
Authenticating with existing credentials...
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
 19:36:48 @ ~/netology/elasticsearch [virt-9]
└─ #  docker push evgenilistopad/elasticsearch:7.17.6
```
- Ссылка на образ в репозитории dockerhub: [elasticsearch:7.17.6](https://hub.docker.com/r/evgenilistopad/elasticsearch)


## Задача 2

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

### Решение задачи 2

- Добавляем три индекса с соответствии с таблицей:
```
 20:01:34 @ ~/netology/elasticsearch [virt-9]
└─ #  curl -X PUT "localhost:9200/ind-1?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}'
 20:01:43 @ ~/netology/elasticsearch [virt-9]
└─ #  curl -X PUT "localhost:9200/ind-2?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 2,
    "number_of_replicas": 1
  }
}'
 20:03:21 @ ~/netology/elasticsearch [virt-9]
└─ #  curl -X PUT "localhost:9200/ind-3?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 4,
    "number_of_replicas": 2
  }
}'
```
- Получение списка индексов и их статусов, используя API:
```
 20:06:18 @ ~/netology/elasticsearch [virt-9]
└─ #  curl 'localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases zadMhzHlSG-nHZUX0e63ZA   1   0         41            0       39mb           39mb
green  open   ind-1            haie6oeORD-civoFoSjxCw   1   0          0            0       226b           226b
yellow open   ind-3            2Ci7DUwFSliGxbf7baP-XA   4   2          0            0       904b           904b
yellow open   ind-2            3LPGxGAFRSeiXlyj_pSO_g   2   1          0            0       452b           452b
```
- Получение состояния кластера `elasticsearch`, используя API:
```
 20:09:32 @ ~/netology/elasticsearch [virt-9]
└─ #  curl -X GET "localhost:9200/_cluster/health?pretty"
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 10,
  "active_shards" : 10,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
```
- Часть индексов и кластер netology_test находятся в состоянии yellow, так как в кластере используется только одна нода, а этого недостаточно для обеспечения отказоустойчивости. 
- Удаление индексов:
```
 20:09:34 @ ~/netology/elasticsearch [virt-9]
└─ #  curl -X DELETE 'http://localhost:9200/_all'
{"acknowledged":true} 20:12:43 @ ~/netology/elasticsearch [virt-9]
└─ #  curl 'localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases zadMhzHlSG-nHZUX0e63ZA   1   0         41            0       39mb           39mb
```

## Задача 3

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

### Решение задачи 3
- Создаем директорию snapshots:
```
 21:06:50 @ ~/netology/elasticsearch [virt-9]
└─ #  docker exec -ti my_elasticsearch bash
root@03aedf9a8a9d:/usr/share/elasticsearch# mkdir /usr/share/elasticsearch/snapshots
root@03aedf9a8a9d:/usr/share/elasticsearch# chown elasticsearch:elasticsearch /usr/share/elasticsearch/snapshots
root@03aedf9a8a9d:/usr/share/elasticsearch# ls -la /usr/share/elasticsearch/snapshots
total 0
drwxr-xr-x 2 elasticsearch elasticsearch  6 Oct 15 18:08 .
drwxrwxr-x 1 root          root          63 Oct 15 18:08 ..
root@03aedf9a8a9d:/usr/share/elasticsearch#
```
- Редактируем файл конфигурации elasticsearch.yml:
```
root@03aedf9a8a9d:/usr/share/elasticsearch# echo 'path.repo: /usr/share/elasticsearch/snapshots' >> /usr/share/elasticsearch/con
fig/elasticsearch.yml
root@03aedf9a8a9d:/usr/share/elasticsearch# cat /usr/share/elasticsearch/config/elasticsearch.yml
cluster.name: "netology_test"
path.data: /var/lib/elasticsearch/data
network.host: 0.0.0.0
path.repo: /usr/share/elasticsearch/snapshots
```
- Используя API регистрируем директорию `/usr/share/elasticsearch/snapshots` как `snapshot repository` c именем `netology_backup`:
```
 21:23:10 @ ~/netology/elasticsearch [virt-9]
└─ #  docker restart my_elasticsearch
my_elasticsearch
 21:23:37 @ ~/netology/elasticsearch [virt-9]
└─ #  curl -X POST "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'{"type": "fs","settings": {"location": "/usr/share/elasticsearch/snapshots"}}'
{
  "acknowledged" : true
}
```
- Создание индекса `test` с 0 реплик и 1 шардом и вывод списка индексов:
```
 21:41:57 @ ~/netology/elasticsearch [virt-9]
└─ # curl -X PUT "localhost:9200/test?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test"
}
 21:43:04 @ ~/netology/elasticsearch [virt-9]
└─ #  curl 'localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases e2KaC6SMSjmYyw2w_U6FrA   1   0         41            0       39mb           39mb
green  open   test             jNDkQT-WRuGF3MBCniqbGA   1   0          0            0       226b           226b
```
- Создание snapshot'а состояния кластера `elasticsearch`:
```
 21:46:12 @ ~/netology/elasticsearch [virt-9]
└─ #  curl -X PUT "localhost:9200/_snapshot/netology_backup/snapshot_1?wait_for_completion=true&pretty"
{
  "snapshot" : {
    "snapshot" : "snapshot_1",
    "uuid" : "DkKahEfhT52_hL4u3byByA",
    "repository" : "netology_backup",
    "version_id" : 7170699,
    "version" : "7.17.6",
    "indices" : [
      ".ds-.logs-deprecation.elasticsearch-default-2022.10.15-000001",
      ".geoip_databases",
      ".ds-ilm-history-5-2022.10.15-000001",
      "test"
    ],
    "data_streams" : [
      "ilm-history-5",
      ".logs-deprecation.elasticsearch-default"
    ],
    "include_global_state" : true,
    "state" : "SUCCESS",
    "start_time" : "2022-10-15T18:46:14.121Z",
    "start_time_in_millis" : 1665859574121,
    "end_time" : "2022-10-15T18:46:15.334Z",
    "end_time_in_millis" : 1665859575334,
    "duration_in_millis" : 1213,
    "failures" : [ ],
    "shards" : {
      "total" : 4,
      "failed" : 0,
      "successful" : 4
    },
    "feature_states" : [
      {
        "feature_name" : "geoip",
        "indices" : [
          ".geoip_databases"
        ]
      }
    ]
  }
}
```
- Cписок файлов в директории со `snapshot`ами:
```
 21:47:50 @ ~/netology/elasticsearch [virt-9]
└─ #  docker exec my_elasticsearch ls -la /usr/share/elasticsearch/snapshots
total 44
drwxr-xr-x 3 elasticsearch elasticsearch   134 Oct 15 18:46 .
drwxrwxr-x 1 root          root             63 Oct 15 18:08 ..
-rw-rw-r-- 1 elasticsearch root           1422 Oct 15 18:46 index-0
-rw-rw-r-- 1 elasticsearch root              8 Oct 15 18:46 index.latest
drwxrwxr-x 6 elasticsearch root            126 Oct 15 18:46 indices
-rw-rw-r-- 1 elasticsearch root          29321 Oct 15 18:46 meta-DkKahEfhT52_hL4u3byByA.dat
-rw-rw-r-- 1 elasticsearch root            709 Oct 15 18:46 snap-DkKahEfhT52_hL4u3byByA.dat
```
- Удаление индекса `test` и создание индекса `test-2`. Вывод списка индексов:
```
 21:50:20 @ ~/netology/elasticsearch [virt-9]
└─ #  curl -X DELETE "localhost:9200/test?pretty"
{
  "acknowledged" : true
}
 21:51:16 @ ~/netology/elasticsearch [virt-9]
└─ #  curl -X PUT "localhost:9200/test-2?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}
 21:52:20 @ ~/netology/elasticsearch [virt-9]
└─ #  curl 'localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases e2KaC6SMSjmYyw2w_U6FrA   1   0         41            0       39mb           39mb
green  open   test-2           RRuGofIjR62NBk_eAmlOQA   1   0          0            0       226b           226b
```
- Восстановление состояния кластера `elasticsearch` из `snapshot`, созданного ранее:
```
 22:14:12 @ ~/netology/elasticsearch [virt-9]
└─ #  curl -X POST "localhost:9200/_snapshot/netology_backup/snapshot_1/_restore?pretty" -H 'Content-Type: application/json' -d'{"indices":"test*","include_global_state": true}'
{
  "accepted" : true
}
```
- Итоговый список индексов:
```
 22:17:34 @ ~/netology/elasticsearch [virt-9]
└─ #  curl 'localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases Ue5I38aTTu2XMepw0Sd5VA   1   0         41            0       39mb           39mb
green  open   test-2           RRuGofIjR62NBk_eAmlOQA   1   0          0            0       226b           226b
green  open   test             dxYdhvO3TL6D_68qZXFF0Q   1   0          0            0       226b           226b
```
