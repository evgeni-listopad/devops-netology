# Домашнее задание к занятию "8.5. Тестирование roles"

## Подготовка к выполнению
1. Установите molecule: `pip3 install "molecule==3.5.2"`
2. Выполните `docker pull aragast/netology:latest` -  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри

### Выполнение подготовки
```
 20:14:40 @ ~ []
└─ #  molecule --version
molecule 3.5.2 using python 3.9
    ansible:2.13.3
    delegated:3.5.2 from molecule
    docker:2.1.0 from molecule_docker requiring collections: community.docker>=3.0.2 ansible.posix>=1.4.0

 20:15:50 @ ~/my-ansible/8.5/test/vector-role [master]
└─ #  docker images | grep aragast
aragast/netology                  latest     b453a84e3f7a   3 months ago    2.46GB

```

## Основная часть

Наша основная цель - настроить тестирование наших ролей. Задача: сделать сценарии тестирования для vector. Ожидаемый результат: все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s centos7` внутри корневой директории clickhouse-role, посмотрите на вывод команды.
2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.
3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
4. Добавьте несколько assert'ов в verify.yml файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска, etc). Запустите тестирование роли повторно и проверьте, что оно прошло успешно.
5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

### Выполнение основной части по разделу Molecule
- Создаем сценарий для тестирования роли vector-role
```
 20:39:20 @ ~/my-ansible/8.5/test/vector-role [master]
└─ #  molecule init scenario --driver-name docker
INFO     Initializing new scenario default...
INFO     Initialized scenario in /root/my-ansible/8.5/test/vector-role/molecule/default successfully
```
- Добавляем в сценарий несколько дистрибутивов (centos:8 и ubuntu:latest)
```
 21:13:04 @ ~/my-ansible/8.5/test/vector-role [master]
└─ #  cat molecule/default/molecule.yml
---
dependency:
  name: galaxy
driver:
  name: docker
lint: |
  ansible-lint .
  yamllint .
platforms:
  - name: cetnos8
    image: docker.io/pycontribs/centos:8
    pre_build_image: true
  - name: centos7
    image: docker.io/pycontribs/centos:7
    pre_build_image: true
  - name: ubuntu
    image: docker.io/pycontribs/ubuntu:latest
    pre_build_image: true

provisioner:
  name: ansible
verifier:
  name: ansible
```
- Тестируем роль во всех дистрибутивах и исправляем ошибки
```
 21:27:25 @ ~/my-ansible/8.5/test/vector-role [master]
└─ #  molecule test
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/f5bcd7/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/root/.cache/ansible-compat/f5bcd7/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/f5bcd7/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /root/.cache/ansible-compat/f5bcd7/roles/netology.vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
WARNING  Listing 2 violation(s) that are fatal
schema[meta]: 2.1 is not of type 'string' (warning)
meta/main.yml:1  Returned errors will not include exact line numbers, but they will mention
the schema name being used as a tag, like ``schema[playbook]``,
``schema[tasks]``.

This rule is not skippable and stops further processing of the file.

Schema bugs should be reported towards [schemas](https://github.com/ansible/schemas) project instead of ansible-lint.

If incorrect schema was picked, you might want to either:

* move the file to standard location, so its file is detected correctly.
* use ``kinds:`` option in linter config to help it pick correct file type.


risky-file-permissions: File permissions unset or incorrect. (warning)
tasks/main.yml:6 Task/Handler: Get RPM packages

You can skip specific rules or tags by adding them to your configuration file:
# .config/ansible-lint.yml
warn_list:  # or 'skip_list' to silence them completely
  - experimental  # all rules tagged as experimental

                            Rule Violation Summary
 count tag                    profile rule associated tags
     1 schema[meta]           basic   core, experimental (warning)
     1 risky-file-permissions safety  unpredictability, experimental (warning)

Passed with min profile: 0 failure(s), 2 warning(s) on 8 files.
A new release of ansible-lint is available: 6.8.6 → 6.10.2 Upgrade by running: pip3 install --user --upgrade ansible-lint
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=cetnos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=cetnos8)
ok: [localhost] => (item=centos7)
ok: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /root/my-ansible/8.5/test/vector-role/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None)
skipping: [localhost] => (item=None)
skipping: [localhost] => (item=None)
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'cetnos8', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'cetnos8', 'pre_build_image': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Synchronization the context] *********************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'cetnos8', 'pre_build_image': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'cetnos8', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 1, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 2, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:8)
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:7)
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/ubuntu:latest)

TASK [Create docker network(s)] ************************************************

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'cetnos8', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=cetnos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) creation to complete] *******************************
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '320362098010.25926', 'results_file': '/root/.ansible_async/320362098010.25926', 'changed': True, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'cetnos8', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '421535332061.25946', 'results_file': '/root/.ansible_async/421535332061.25946', 'changed': True, 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '564296664790.25977', 'results_file': '/root/.ansible_async/564296664790.25977', 'changed': True, 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=6    changed=2    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [ubuntu]
ok: [cetnos8]
ok: [centos7]

TASK [Include vector-role] *****************************************************
WARNING  Retrying execution failure 4 of: ansible-playbook --inventory /root/.cache/molecule/vector-role/default/inventory --skip-tags molecule-notest,notest /root/my-ansible/8.5/test/vector-role/molecule/default/converge.yml
WARNING  An error occurred during the test sequence action: 'converge'. Cleaning up.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=cetnos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item=cetnos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory

```
- Добавляем несколько assert'ов в verify.yml. Тестируем повторно.
```
 21:36:25 @ ~/my-ansible/8.5/test/vector-role [master]
└─ #  cat molecule/default/verify.yml
---
# This is an example playbook to execute Ansible tests.

- name: Verify
  hosts: all
  gather_facts: false
  tasks:
  - name: Get Vector version
    ansible.builtin.command: "vector --version"
    changed_when: false
    register: vector_version
  - name: Validation Vector configuration
    ansible.builtin.command: "vector validate --no-environment --config-yaml {{ vector_config_path }}"
    changed_when: false
    register: vector_validate
  - name: Vector service status
    ansible.builtin.systemd:
      name: "vector"
    register: vector_service_status
 23:36:31 @ ~/my-ansible/8.5/test/vector-role [master]
└─ #  molecule test
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/f5bcd7/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/root/.cache/ansible-compat/f5bcd7/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/f5bcd7/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /root/.cache/ansible-compat/f5bcd7/roles/netology.vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
WARNING  Listing 2 violation(s) that are fatal
schema[meta]: 2.1 is not of type 'string' (warning)
meta/main.yml:1  Returned errors will not include exact line numbers, but they will mention
the schema name being used as a tag, like ``schema[playbook]``,
``schema[tasks]``.

This rule is not skippable and stops further processing of the file.

Schema bugs should be reported towards [schemas](https://github.com/ansible/schemas) project instead of ansible-lint.

If incorrect schema was picked, you might want to either:

* move the file to standard location, so its file is detected correctly.
* use ``kinds:`` option in linter config to help it pick correct file type.


risky-file-permissions: File permissions unset or incorrect. (warning)
tasks/main.yml:6 Task/Handler: Get RPM packages

You can skip specific rules or tags by adding them to your configuration file:
# .config/ansible-lint.yml
warn_list:  # or 'skip_list' to silence them completely
  - experimental  # all rules tagged as experimental

                            Rule Violation Summary
 count tag                    profile rule associated tags
     1 schema[meta]           basic   core, experimental (warning)
     1 risky-file-permissions safety  unpredictability, experimental (warning)

Passed with min profile: 0 failure(s), 2 warning(s) on 8 files.
A new release of ansible-lint is available: 6.8.6 → 6.10.2 Upgrade by running: pip3 install --user --upgrade ansible-lint
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=cetnos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=cetnos8)
ok: [localhost] => (item=centos7)
ok: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /root/my-ansible/8.5/test/vector-role/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None)
skipping: [localhost] => (item=None)
skipping: [localhost] => (item=None)
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'cetnos8', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'cetnos8', 'pre_build_image': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Synchronization the context] *********************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'cetnos8', 'pre_build_image': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'cetnos8', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 1, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 2, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:8)
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:7)
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/ubuntu:latest)

TASK [Create docker network(s)] ************************************************

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'cetnos8', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=cetnos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) creation to complete] *******************************
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '554029998928.28629', 'results_file': '/root/.ansible_async/554029998928.28629', 'changed': True, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'cetnos8', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '877254244602.28649', 'results_file': '/root/.ansible_async/877254244602.28649', 'changed': True, 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '959569843890.28688', 'results_file': '/root/.ansible_async/959569843890.28688', 'changed': True, 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=6    changed=2    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [ubuntu]
ok: [cetnos8]
ok: [centos7]

TASK [Include vector-role] *****************************************************
WARNING  Retrying execution failure 4 of: ansible-playbook --inventory /root/.cache/molecule/vector-role/default/inventory --skip-tags molecule-notest,notest /root/my-ansible/8.5/test/vector-role/molecule/default/converge.yml
WARNING  An error occurred during the test sequence action: 'converge'. Cleaning up.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=cetnos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item=cetnos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
```
- Добавлен новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.
[Molecule_default with docker tag 1.0.0](./TASK_8.5/molecule/default)


### Tox

1. Добавьте в директорию с vector-role файлы из директории example.
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo - путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
6. Пропишите правильную команду в `tox.ini` для того чтобы запускался облегчённый сценарий.
8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

### Выполнение основной части по разделу Tox
- Запускаем `docker run` для образа `aragast/netology:latest`. Заходим внутрь контейнера.
```
 00:15:12 @ ~/my-ansible/8.5/test/vector-role [master]
└─ #  docker run --privileged=True -v /root/my-ansible/8.5/test/vector-role:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash
[root@b8007041fecf vector-role]#
```
- Внутри контейнера выполняем команду `tox`. В сценарии molecule.yml оставлена только centos8. В качестве драйвера выбран `podman`. Запуск выполнился для 4-х сочетаний python_ansible:  py37-ansible210, py37-ansible30, py39-ansible210,   py39-ansible30

```

[root@e6881a03b1e4 vector-role]# tox
py37-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.        3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2022.12.7,cffi==1        .15.1,chardet==5.1.0,charset-normalizer==2.1.1,click==8.1.3,click-help-colors==0.9.1,commonmark==0.9.1,cookiecutter==2        .1.1,cryptography==39.0.0,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.0.0,Jinja2==3.1.2,jinja2-time==0        .2.0,jmespath==1.0.1,lxml==4.9.2,MarkupSafe==2.1.1,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.        12.0,pathspec==0.10.3,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slug        ify==7.0.0,PyYAML==5.4.1,requests==2.28.1,rich==13.0.1,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.2.1,six        ==1.16.0,subprocess-tee==0.3.5,tenacity==8.1.0,text-unidecode==1.3,typing_extensions==4.4.0,urllib3==1.26.13,wcmatch==        8.4.1,yamllint==1.26.3,zipp==3.11.0
py37-ansible210 run-test-pre: PYTHONHASHSEED='1234854530'
py37-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
INFO     compatibility scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, id        empotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
WARNING  Failed to locate command: [Errno 2] No such file or directory: 'git': 'git'
INFO     Guessed /opt/vector-role as project root directory
INFO     Using /root/.cache/ansible-lint/b984a4/roles/netology.vector_role symlink to current repository in order to e        nable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-li        nt/b984a4/roles
INFO     Running compatibility > dependency
INFO     Running ansible-galaxy collection install --force -v containers.podman:>=1.7.0
INFO     Running ansible-galaxy collection install --force -v ansible.posix:>=1.3.0
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running compatibility > lint
INFO     Lint is disabled.
INFO     Running compatibility > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running compatibility > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '121333343688.93', 'results_file': '/roo        t/.ansible_async/121333343688.93', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:8'        , 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running compatibility > syntax

playbook: /opt/vector-role/molecule/compatibility/converge.yml
INFO     Running compatibility > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="centos8 registry username: None specified")

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: docker.io/pycontribs/centos:8")

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=centos8)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=docker.io/pycontribs/centos:8)

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="centos8 command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=centos8: None specified)

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos8)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (299 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (298 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (297 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (296 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (295 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (294 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (293 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (292 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (291 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (290 retries left).
changed: [localhost] => (item=centos8)

PLAY RECAP *********************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running compatibility > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running compatibility > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos8]

TASK [Include vector-role] *****************************************************

PLAY RECAP *********************************************************************
centos8                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

WARNING  An error occurred during the test sequence action: 'converge'. Cleaning up.
INFO     Running compatibility > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running compatibility > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '123682403461.738', 'results_file': '/root/.ansible_async/123682403461.738', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
py37-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==2.1.1,click==8.1.3,click-help-colors==0.9.1,commonmark==0.9.1,cookiecutter==2.1.1,cryptography==39.0.0,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.0.0,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,lxml==4.9.2,MarkupSafe==2.1.1,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.10.3,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==7.0.0,PyYAML==5.4.1,requests==2.28.1,rich==13.0.1,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.1.0,text-unidecode==1.3,typing_extensions==4.4.0,urllib3==1.26.13,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.11.0
py37-ansible30 run-test-pre: PYTHONHASHSEED='1234854530'
py37-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
INFO     compatibility scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
WARNING  Failed to locate command: [Errno 2] No such file or directory: 'git': 'git'
INFO     Guessed /opt/vector-role as project root directory
INFO     Using /root/.cache/ansible-lint/b984a4/roles/netology.vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/b984a4/roles
INFO     Running compatibility > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running compatibility > lint
INFO     Lint is disabled.
INFO     Running compatibility > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running compatibility > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '731854751960.885', 'results_file': '/root/.ansible_async/731854751960.885', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running compatibility > syntax

playbook: /opt/vector-role/molecule/compatibility/converge.yml
INFO     Running compatibility > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="centos8 registry username: None specified")

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: docker.io/pycontribs/centos:8")

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=centos8)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=docker.io/pycontribs/centos:8)

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="centos8 command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=centos8: None specified)

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos8)

TASK [Wait for instance(s) creation to complete] *******************************
changed: [localhost] => (item=centos8)

PLAY RECAP *********************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running compatibility > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running compatibility > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos8]

TASK [Include vector-role] *****************************************************

PLAY RECAP *********************************************************************
centos8                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

WARNING  An error occurred during the test sequence action: 'converge'. Cleaning up.
INFO     Running compatibility > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running compatibility > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '290763395117.1317', 'results_file': '/root/.ansible_async/290763395117.1317', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
py39-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==2.2.7,ansible-lint==5.1.3,arrow==1.2.3,attrs==22.2.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==2.1.1,click==8.1.3,click-help-colors==0.9.1,commonmark==0.9.1,cookiecutter==2.1.1,cryptography==39.0.0,distro==1.8.0,enrich==1.2.7,idna==3.4,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,jsonschema==4.17.3,lxml==4.9.2,MarkupSafe==2.1.1,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.10.3,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,pyrsistent==0.19.3,python-dateutil==2.8.2,python-slugify==7.0.0,PyYAML==5.4.1,requests==2.28.1,rich==13.0.1,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.1.0,text-unidecode==1.3,urllib3==1.26.13,wcmatch==8.4.1,yamllint==1.26.3
py39-ansible210 run-test-pre: PYTHONHASHSEED='1234854530'
py39-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
INFO     compatibility scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
WARNING  Failed to locate command: [Errno 2] No such file or directory: 'git'
INFO     Guessed /opt/vector-role as project root directory
INFO     Using /root/.cache/ansible-lint/b984a4/roles/netology.vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/b984a4/roles
INFO     Running compatibility > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running compatibility > lint
INFO     Lint is disabled.
INFO     Running compatibility > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running compatibility > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '701348131597.1438', 'results_file': '/root/.ansible_async/701348131597.1438', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running compatibility > syntax

playbook: /opt/vector-role/molecule/compatibility/converge.yml
INFO     Running compatibility > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="centos8 registry username: None specified")

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: docker.io/pycontribs/centos:8")

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=centos8)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=docker.io/pycontribs/centos:8)

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="centos8 command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=centos8: None specified)

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos8)

TASK [Wait for instance(s) creation to complete] *******************************
changed: [localhost] => (item=centos8)

PLAY RECAP *********************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running compatibility > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running compatibility > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos8]

TASK [Include vector-role] *****************************************************

PLAY RECAP *********************************************************************
centos8                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

WARNING  An error occurred during the test sequence action: 'converge'. Cleaning up.
INFO     Running compatibility > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running compatibility > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '529014077898.1843', 'results_file': '/root/.ansible_async/529014077898.1843', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
py39-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==2.2.7,ansible-lint==5.1.3,arrow==1.2.3,attrs==22.2.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==2.1.1,click==8.1.3,click-help-colors==0.9.1,commonmark==0.9.1,cookiecutter==2.1.1,cryptography==39.0.0,distro==1.8.0,enrich==1.2.7,idna==3.4,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,jsonschema==4.17.3,lxml==4.9.2,MarkupSafe==2.1.1,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.10.3,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,pyrsistent==0.19.3,python-dateutil==2.8.2,python-slugify==7.0.0,PyYAML==5.4.1,requests==2.28.1,rich==13.0.1,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.1.0,text-unidecode==1.3,urllib3==1.26.13,wcmatch==8.4.1,yamllint==1.26.3
py39-ansible30 run-test-pre: PYTHONHASHSEED='1234854530'
py39-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
INFO     compatibility scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
WARNING  Failed to locate command: [Errno 2] No such file or directory: 'git'
INFO     Guessed /opt/vector-role as project root directory
INFO     Using /root/.cache/ansible-lint/b984a4/roles/netology.vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/b984a4/roles
INFO     Running compatibility > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running compatibility > lint
INFO     Lint is disabled.
INFO     Running compatibility > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running compatibility > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '365555224436.1955', 'results_file': '/root/.ansible_async/365555224436.1955', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running compatibility > syntax

playbook: /opt/vector-role/molecule/compatibility/converge.yml
INFO     Running compatibility > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="centos8 registry username: None specified")

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: docker.io/pycontribs/centos:8")

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=centos8)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=docker.io/pycontribs/centos:8)

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="centos8 command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=centos8: None specified)

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos8)

TASK [Wait for instance(s) creation to complete] *******************************
changed: [localhost] => (item=centos8)

PLAY RECAP *********************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running compatibility > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running compatibility > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos8]

TASK [Include vector-role] *****************************************************

PLAY RECAP *********************************************************************
centos8                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

WARNING  An error occurred during the test sequence action: 'converge'. Cleaning up.
INFO     Running compatibility > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running compatibility > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '882883398769.2359', 'results_file': '/root/.ansible_async/882883398769.2359', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory

```
- Создаем облегчённый сценарий для `molecule` с драйвером `molecule_podman`.
```
 01:11:12 @ ~/my-ansible/8.5/test/vector-role/molecule/light [master]
└─ #  cat molecule.yml
---
dependency:
  name: galaxy
driver:
  name: podman
lint: |
  ansible-lint .
  yamllint .
platforms:
  - name: cetnos8
    image: docker.io/pycontribs/centos:8
    pre_build_image: true

provisioner:
  name: ansible
verifier:
  name: ansible
scenario:
  test_sequence:
    - create
    - converge
    - destroy

```
- Корректируем в `tox.ini` для того чтобы запускался облегчённый сценарий.
```
[tox]
minversion = 1.8
basepython = python3.9
envlist = py{39}-ansible{210}
skipsdist = true

[testenv]
passenv = *
deps =
    -r tox-requirements.txt
    ansible210: ansible<3.0
    ansible30: ansible<3.1
commands =
    {posargs:molecule test -s tox --destroy always}
```
- Запускаем облегченный сценарий.
```
 02:15:00 @ ~/my-ansible/8.5/test/vector-role [master]
└─ #  docker run --privileged=True -v /root/my-ansible/8.5/test/vector-role:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash
[root@e82dd86ccd8c vector-role]# tox
py39-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==2.2.7,ansible-lint==5.1.3,arrow==1.2.3,attrs==22.2.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==2.1.1,click==8.1.3,click-help-colors==0.9.1,commonmark==0.9.1,cookiecutter==2.1.1,cryptography==39.0.0,distro==1.8.0,enrich==1.2.7,idna==3.4,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,jsonschema==4.17.3,lxml==4.9.2,MarkupSafe==2.1.1,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.10.3,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,pyrsistent==0.19.3,python-dateutil==2.8.2,python-slugify==7.0.0,PyYAML==5.4.1,requests==2.28.1,rich==13.0.1,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.1.0,text-unidecode==1.3,urllib3==1.26.13,wcmatch==8.4.1,yamllint==1.26.3
py39-ansible210 run-test-pre: PYTHONHASHSEED='2385006595'
py39-ansible210 run-test: commands[0] | molecule test -s tox --destroy always
INFO     tox scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
WARNING  Failed to locate command: [Errno 2] No such file or directory: 'git'
INFO     Guessed /opt/vector-role as project root directory
INFO     Using /root/.cache/ansible-lint/b984a4/roles/netology.vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/b984a4/roles
INFO     Running tox > dependency
INFO     Running ansible-galaxy collection install --force -v containers.podman:>=1.7.0
INFO     Running ansible-galaxy collection install --force -v ansible.posix:>=1.3.0
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running tox > lint
INFO     Lint is disabled.
INFO     Running tox > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running tox > destroy
INFO     Sanity checks: 'podman'

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="centos8 registry username: None specified")

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: docker.io/pycontribs/centos:8")

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=centos8)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=docker.io/pycontribs/centos:8)

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="centos8 command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=centos8: None specified)

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos8)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (299 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (298 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (297 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (296 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (295 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (294 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (293 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (292 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (291 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (290 retries left).
changed: [localhost] => (item=centos8)

PLAY RECAP *********************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running tox > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running tox > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos8]

TASK [Include vector-role] *****************************************************

PLAY RECAP *********************************************************************
centos8                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running tox > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running tox > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '59494645448.634', 'results_file': '/root/.ansible_async/59494645448.634', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory

```
- Добавляем новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.
[Molecule_light with docker tag 1.0.1](./TASK_8.5/molecule/light)

[Ссылка на репозиторий](./TASK_8.5)



