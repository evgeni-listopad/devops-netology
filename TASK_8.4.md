# Домашнее задание к занятию "8.4. Работа с roles"

## Подготовка к выполнению
1. (Необязательно) Познакомтесь с [lighthouse](https://youtu.be/ymlrNlaHzIY?t=929)
2. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.
3. Добавьте публичную часть своего ключа к своему профилю в github.

## Основная часть

Наша основная цель - разбить наш playbook на отдельные roles. Задача: сделать roles для clickhouse, vector и lighthouse и написать playbook для использования этих ролей. Ожидаемый результат: существуют три ваших репозитория: два с roles и один с playbook.

1. Создать в старой версии playbook файл `requirements.yml` и заполнить его следующим содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.11.0"
       name: clickhouse 
   ```
2. При помощи `ansible-galaxy` скачать себе эту роль.
3. Создать новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
5. Перенести нужные шаблоны конфигов в `templates`.
6. Описать в `README.md` обе роли и их параметры.
7. Повторите шаги 3-6 для lighthouse. Помните, что одна роль должна настраивать один продукт.
8. Выложите все roles в репозитории. Проставьте тэги, используя семантическую нумерацию Добавьте roles в `requirements.yml` в playbook.
9. Переработайте playbook на использование roles. Не забудьте про зависимости lighthouse и возможности совмещения `roles` с `tasks`.
10. Выложите playbook в репозиторий.
11. В ответ приведите ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

### Выполнение задания 8.4

1. Создан файл `requirements.yml`:
```
 20:00:14 @ ~/my-ansible/8.4 []
└─ #  cat requirements.yml
---
  - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
    scm: git
    version: "1.11.0"
    name: clickhouse
```

2. Скачана роль `clickhouse`:
```
 20:05:32 @ ~/my-ansible/8.4 []
└─ #  ansible-galaxy install -r requirements.yml -p roles
Starting galaxy role install process
- extracting clickhouse to /root/my-ansible/8.4/roles/clickhouse
- clickhouse (1.11.0) was installed successfully
```

3. Созданы новые каталоги для `vector-role` и `lighthouse-role`:
```
 20:09:15 @ ~/my-ansible/8.4 []
└─ #  ansible-galaxy role init vector-role
- Role vector-role was created successfully

 20:09:20 @ ~/my-ansible/8.4 []
└─ #  ansible-galaxy role init lighthouse-role
- Role lighthouse-role was created successfully
```

4. На основе tasks из старого playbook заполнены новые roles. Разнесены переменные между `vars` и `default`.
[vector-role_tasks](https://github.com/evgeni-listopad/vector-role/blob/master/tasks/main.yml)
[lighthouse-role_tasks](https://github.com/evgeni-listopad/lighthouse-role/blob/master/tasks/main.yml)

5. Перенесены нужные шаблоны конфигов в `templates`.
[vector-role_templates](https://github.com/evgeni-listopad/vector-role/tree/master/templates)
[lighthouse-role_templates](https://github.com/evgeni-listopad/lighthouse-role/tree/master/templates)

6. В файлах `README.md` описаны обе роли.
[vector-role_README](https://github.com/evgeni-listopad/vector-role/blob/master/README.md)
[lighthouse-role_README](https://github.com/evgeni-listopad/lighthouse-role/blob/master/README.md)

7. Шаги 3-6 выполнены и для vector, и для lighthouse. Одна роль настраивает один продукт.

8. Все roles выложены в репозитории. Проставлены тэги, используя семантическую нумерацию. Roles добавлены в `requirements.yml` в playbook.
[vector-role](https://github.com/evgeni-listopad/vector-role/tree/0.25.1)
[lighthouse-role](https://github.com/evgeni-listopad/lighthouse-role/tree/1.1.1)
```
 20:17:14 @ ~/my-ansible/8.4 []
└─ #  cat requirements.yml
---
  - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
    scm: git
    version: "1.11.0"
    name: clickhouse
  - src: git@github.com:evgeni-listopad/vector-role.git
    scm: git
    version: "0.25.1"
    name: vector-role
  - src: git@github.com:evgeni-listopad/lighthouse-role.git
    scm: git
    version: "1.1.1"
    name: lighthouse-role
 20:22:06 @ ~/my-ansible/8.4 []
└─ #  ansible-galaxy install -r requirements.yml -p roles
Starting galaxy role install process
- extracting clickhouse to /root/my-ansible/8.4/roles/clickhouse
- clickhouse (1.11.0) was installed successfully
- extracting vector-role to /root/my-ansible/8.4/roles/vector-role
- vector-role (0.25.1) was installed successfully
- extracting lighthouse-role to /root/my-ansible/8.4/roles/lighthouse-role
- lighthouse-role (1.1.1) was installed successfully
```

9. Переработан playbook на использование roles. Установка зависимостей `lighthouse` реализована в виде `pre_tasks`. 
```
 20:32:03 @ ~/my-ansible/8.4 []
└─ #  cat site.yml
---
# Clickhouse
- name: Install Clickhouse
  tags: clickhouse
  hosts: clickhouse-01
  roles:
    - clickhouse
# Vector
- name: Install Vector
  tags: vector
  hosts: vector-01
  roles:
    - vector-role
# Lighthouse
- name: Install Lighthouse
  tags: lighthouse
  hosts: lighthouse-01
  pre_tasks:
    - name: Install required packages
      become: true
      ansible.builtin.yum:
        name: "{{ item }}"
      with_items: "{{ necessary_packages }}"
  roles:
    - lighthouse-role
```

10. Playbook выложен в репозиторий.
11. Ссылки:
[Репозиторий vector-role](https://github.com/evgeni-listopad/vector-role)
[Репозиторий lighthouse-role](https://github.com/evgeni-listopad/lighthouse-role)
[Репозиторий с playbook](https://github.com/evgeni-listopad/devops-netology/tree/main/TASK_8.4)
