# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

### Решение задачи 1
```
[root@cloneserv my_test]# cat index.html
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I'm DevOps Engineer!</h1>
</body>
</html>

[root@cloneserv my_test]# cat Dockerfile
FROM nginx
COPY ./index.html /usr/share/nginx/html

[root@cloneserv my_test]# docker build -t evgenilistopad/nginx:1.23.1 .
Sending build context to Docker daemon  3.072kB
Step 1/2 : FROM nginx
 ---> 2b7d6430f78d
Step 2/2 : COPY ./index.html /usr/share/nginx/html
 ---> 4d076a063809
Successfully built 4d076a063809
Successfully tagged evgenilistopad/nginx:1.23.1

[root@cloneserv my_test]# docker push evgenilistopad/nginx:1.23.1
The push refers to repository [docker.io/evgenilistopad/nginx]
e947c953ffc1: Pushed
73993eeb8aa2: Mounted from library/nginx
2c31eef17db8: Mounted from library/nginx
7b9055fc8058: Mounted from library/nginx
04ab349b7b3b: Mounted from library/nginx
226117031573: Mounted from library/nginx
6485bed63627: Mounted from library/nginx
1.23.1: digest: sha256:751d580d4051e8c258723343d46f67b667e719dc20d932da96d7e31ddc0a0d52 size: 1777
```
Ссылка на репозиторий по задаче 1 https://hub.docker.com/r/evgenilistopad/nginx

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

### Решение задачи 2

Сценарии:

- Высоконагруженное монолитное java веб-приложение;
```
Так как приложение монолитное, то использование docker не очень подходит,
поскольку отсутствует реализация компонентов приложения в микросервисах.
А раз приложение еще и высоконагруженное, то лучше использовть физическую 
машину или аппаратную виртуализацию.
```
- Nodejs веб-приложение;
```
Считаю, что для Nodejs уместно использовать docker. Для этого существует 
официальный docker-образ https://hub.docker.com/_/node/
```
- Мобильное приложение c версиями для Android и iOS;
```
Насколько я понимаю мобильное приложение ставится непосредственно на 
мобильное устройство, то есть на физическую машину.
Допускаю, что для отладки или тестирования приложения можно использовать
виртуальные машины с Android или iOS, а также docker-контейнеры с этими ОС.
```
- Шина данных на базе Apache Kafka;
```
Для тестирования вполне подойдет и реализация на базе docker-контейнера.
Но для боевой высоконагруженной системы со строгими требованиями по отказоустойчивости 
лучше использовать виртуальную или физическую машину, поскольку шина на базе Apache Kafka
обеспечивает по сути связь микросервисов между собой.
```
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
```
Считаю, что использование Docker-контейнеров хорошо подходит для данного сценария.
На Docker hub есть официальные образы для каждого из 3-х вышеперечисленных сервисов.
Управление кластером можно сделать через Docker Swarm.
```
- Мониторинг-стек на базе Prometheus и Grafana;
```
Использование Docker-контейнеров хорошо подходит и для данного сценария.
На Docker hub есть образы и для Prometheus, и для Grafana (в лекции по Docker Compose 
использовались образы prom/prometheus:v2.17.1 и grafana/grafana:7.4.2).
Управление группой Docker-контейнеров можно сделать через Docker Compose.
```
- MongoDB, как основное хранилище данных для java-приложения;
```
Поскольку в данном сценарии MongoDB рассматривается как основное хранилище данных, 
лучше использовать либо физическую машину, либо виртуальную, но с подключаемой внешней СХД.
```
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.
```
Gitlab-сервер содержит реализацию CI/CD и приватный Container Registry.
Инсталляцию Gitlab-сервера компании целесообразно выполнять на виртуальную или физическую машину и 
желательно с отказоустойчивой кластеризацией для повышения надежности.
```

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

### Решение задачи 3
```
[root@cloneserv ~]# docker run -it --rm -d --name centos8 -v /root/data/:/data/ centos:centos8
Unable to find image 'centos:centos8' locally
centos8: Pulling from library/centos
a1d0c7532777: Pull complete
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:centos8
5714ff8e31ed966500eb3b92a0af623277390a1e11cf4f4a648be221cc76e1cd
[root@cloneserv ~]# docker run -it --rm -d --name debian_st -v /root/data/:/data/ debian:stable
Unable to find image 'debian:stable' locally
stable: Pulling from library/debian
0b5aea898977: Pull complete
Digest: sha256:3d2aa501c4cefd4415895b1d877dfbba0739cab1d58cbe8f1baa3f01b6739690
Status: Downloaded newer image for debian:stable
e7d838366f521cb21cadea1e4647a2ed208c2f57b96ecf0f6e35cc9d564f80ea
[root@cloneserv ~]# docker ps
CONTAINER ID   IMAGE            COMMAND       CREATED          STATUS          PORTS     NAMES
e7d838366f52   debian:stable    "bash"        31 seconds ago   Up 30 seconds             debian_st
5714ff8e31ed   centos:centos8   "/bin/bash"   2 minutes ago    Up 2 minutes              centos8
[root@cloneserv ~]# docker exec -it centos8 bash
[root@5714ff8e31ed /]# echo "centos8_content" > /data/centos8_file
[root@5714ff8e31ed /]# exit
exit
[root@cloneserv ~]# echo "host_content" > /root/data/host_file
[root@cloneserv ~]# docker exec -it debian_st bash
root@e7d838366f52:/# ls /data
centos8_file  host_file
root@e7d838366f52:/# cat /data/centos8_file /data/host_file
centos8_content
host_content
root@e7d838366f52:/# exit
exit
[root@cloneserv ~]#
```

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.

### Решение задачи 4 (*)
```
[root@cloneserv ansible]# docker build -t evgenilistopad/ansible:2.10.0 .
Sending build context to Docker daemon  3.072kB
Step 1/5 : FROM alpine:3.14
3.14: Pulling from library/alpine
c7ed990a2339: Pull complete
Digest: sha256:1ab24b3b99320975cca71716a7475a65d263d0b6b604d9d14ce08f7a3f67595c
Status: Downloaded newer image for alpine:3.14
 ---> dd53f409bf0b
------------------------------------------------------------------------
-----------------------------ВЫВОД ПРОПУЩЕН-----------------------------
------------------------------------------------------------------------
Step 5/5 : CMD [ "ansible-playbook", "--version" ]
 ---> Running in c469b83aa61f
Removing intermediate container c469b83aa61f
 ---> 3d9cc4c27b64
Successfully built 3d9cc4c27b64
Successfully tagged evgenilistopad/ansible:2.10.0
[root@cloneserv ansible]#
[root@cloneserv ansible]# docker push evgenilistopad/ansible:2.10.0
The push refers to repository [docker.io/evgenilistopad/ansible]
695837d05e15: Pushed
d6977316b2c1: Pushed
63493a9ab2d4: Mounted from library/alpine
2.10.0: digest: sha256:c14b58bf1b98898f91a2e710eaf2206452b32391aed5fc595a48444e8ed33ed3 size: 947
[root@cloneserv ansible]#
```
Ссылка на репозиторий по задаче 4 https://hub.docker.com/r/evgenilistopad/ansible

