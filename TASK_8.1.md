# Домашнее задание к занятию "8.1. Введение в Ansible"

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.
2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.
6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

### Решение основной части
1. Запускаем playbook на окружении из `test.yml`, факт `some_fact` для указанного хоста при выполнении playbook'a имеет значение `12`:
```
 21:48:46 @ ~/netology/hw_ansible_ci_monitoring/08-ansible-01-base/playbook []
└─ #  ansible-playbook -i inventory/test.yml site.yml

PLAY [Print os facts] **********************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************
ok: [localhost]

TASK [Print OS] ****************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "CentOS"
}

TASK [Print fact] **************************************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP *********************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
2. Находим файл с переменными (group_vars), в котором задаётся найденное в первом пункте значение и меняем его на 'all default fact':
```
 22:02:59 @ ~/netology/hw_ansible_ci_monitoring/08-ansible-01-base/playbook []
└─ #  cat group_vars/all/examp.yml
---
  some_fact: "all default fact"
```
3. Создадим (используется `docker`) собственное окружение для проведения дальнейших испытаний:
```
 22:16:01 @ ~/netology/hw_ansible_ci_monitoring/08-ansible-01-base/playbook []
└─ #  docker ps
CONTAINER ID   IMAGE      COMMAND       CREATED              STATUS              PORTS     NAMES
34d8956ba75e   ubuntu:20.04   "bash"        3 minutes ago    Up 3 minutes              ubuntu
7480613ee439   centos:7       "/bin/bash"   21 minutes ago   Up 21 minutes             centos7
```
4. Запускаем playbook на окружении из `prod.yml`. Полученные значения `some_fact` для каждого из `managed host`: 
- "el" для `centos7`;
- "deb" для `ubuntu`;
```
 22:36:16 @ ~/netology/hw_ansible_ci_monitoring/08-ansible-01-base/playbook []
└─ #  ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] **********************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ****************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP *********************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
5. Добавляем факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.
```
 22:54:21 @ ~/netology/hw_ansible_ci_monitoring/08-ansible-01-base/playbook/group_vars []
└─ #  grep -R "default fact"
all/examp.yml:  some_fact: "all default fact"
deb/examp.yml:  some_fact: "deb default fact"
el/examp.yml:  some_fact: "el default fact"
```
6. Повторяем запуск playbook на окружении `prod.yml`. Убеждаемся, что выдаются корректные значения для всех хостов.
```
 22:56:24 @ ~/netology/hw_ansible_ci_monitoring/08-ansible-01-base/playbook []
└─ #  ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] **********************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ****************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *********************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```
7. При помощи `ansible-vault` шифруем факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
```
 22:56:36 @ ~/netology/hw_ansible_ci_monitoring/08-ansible-01-base/playbook []
└─ #  ansible-vault encrypt group_vars/deb/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful
 22:58:51 @ ~/netology/hw_ansible_ci_monitoring/08-ansible-01-base/playbook []
└─ #  ansible-vault encrypt group_vars/el/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful
```
8. Запускаем playbook на окружении `prod.yml`. При запуске `ansible` запрашивает пароль. Убеждаемся в работоспособности:
```
 23:01:14 @ ~/netology/hw_ansible_ci_monitoring/08-ansible-01-base/playbook []
└─ #  ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] **********************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ****************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] **************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *********************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```
9. Выводим при помощи `ansible-doc` список плагинов для подключения. Для работы на `control node` выбираем `local`.
```
 23:06:48 @ ~/netology/hw_ansible_ci_monitoring/08-ansible-01-base/playbook []
└─ #  ansible-doc -t connection -l
ansible.netcommon.grpc         Provides a persistent connection using the gRPC protocol
ansible.netcommon.httpapi      Use httpapi to run command on network appliances
---------------------------ВЫВОД ОПУЩЕН----------------------------------------------------
kubernetes.core.kubectl        Execute tasks in pods running on Kubernetes
local                          execute on controller
paramiko_ssh                   Run tasks via python ssh (paramiko)
psrp                           Run tasks over Microsoft PowerShell Remoting Protocol
ssh                            connect via SSH client binary
winrm                          Run tasks over Microsoft's WinRM
```
10. В `prod.yml` добавим новую группу хостов с именем  `local`, в ней разместим localhost с типом подключения `local`. 
```
 23:14:17 @ ~/netology/hw_ansible_ci_monitoring/08-ansible-01-base/playbook/inventory []
└─ #  cat prod.yml
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
```
11. Запускаем playbook на окружении `prod.yml`. При запуске `ansible` вводим пароль. Факты `some_fact` для каждого из хостов определены из верных `group_vars`.
```
 23:16:40 @ ~/netology/hw_ansible_ci_monitoring/08-ansible-01-base/playbook []
└─ #  ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] **********************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]
ok: [localhost]

TASK [Print OS] ****************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "CentOS"
}

TASK [Print fact] **************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP *********************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```
12. Заполняем `README.md` ответами на вопросы. [Ссылка](https://github.com/evgeni-listopad/devops-netology/tree/main/TASK_8.1) на репозиторий с изменённым `playbook` и заполненным `README.md`.


## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.
3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.

### Решение необязательной части 
1. Расшифровываем все зашифрованные файлы с переменными:
```
 00:06:05 @ ~/netology/hw_ansible_ci_monitoring/08-ansible-01-base/playbook []
└─ #  ansible-vault decrypt group_vars/deb/examp.yml
Vault password:
Decryption successful
 00:06:40 @ ~/netology/hw_ansible_ci_monitoring/08-ansible-01-base/playbook []
└─ #  ansible-vault decrypt group_vars/el/examp.yml
Vault password:
Decryption successful
```
2. Шифруем отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавляем полученное значение в `group_vars/all/exmp.yml`
```
 00:06:54 @ ~/netology/hw_ansible_ci_monitoring/08-ansible-01-base/playbook []
└─ #  ansible-vault encrypt_string
New Vault password:
Confirm New Vault password:
Reading plaintext input from stdin. (ctrl-d to end input, twice if your content does not already have a newline)
PaSSw0rd
Encryption successful
!vault |
          $ANSIBLE_VAULT;1.1;AES256
          65353034393661393665393339326162393732353766373864643039383032376264326235306135
          3464316562306266353935343265646664643931643465330a316665386530366262386139386161
          61343635623130643435613034303731343931653832353930643362373532343037636532343162
          3439343336366637390a396662373839663335303638616135636363336666653266396632393532
          3932 00:11:28 @ ~/netology/hw_ansible_ci_monitoring/08-ansible-01-base/playbook []
└─ #  vim group_vars/all/examp.yml
 00:12:29 @ ~/netology/hw_ansible_ci_monitoring/08-ansible-01-base/playbook []
└─ #  cat group_vars/all/examp.yml
---
  some_fact: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          65353034393661393665393339326162393732353766373864643039383032376264326235306135
          3464316562306266353935343265646664643931643465330a316665386530366262386139386161
          61343635623130643435613034303731343931653832353930643362373532343037636532343162
          3439343336366637390a396662373839663335303638616135636363336666653266396632393532
          3932
```
3. Запускаем `playbook`, убеждаемся, что для нужных хостов применился новый `fact`.
```
 00:14:59 @ ~/netology/hw_ansible_ci_monitoring/08-ansible-01-base/playbook []
└─ #  ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] **********************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]
ok: [localhost]

TASK [Print OS] ****************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "CentOS"
}

TASK [Print fact] **************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}

PLAY RECAP *********************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```
4. Добавляем новую группу хостов `fedora`, содержимое переменной для неё задаем `fedora default fact`. Запускаем `playbook`, убеждаемся, что всё работает.
```
 00:20:16 @ ~/netology/hw_ansible_ci_monitoring/08-ansible-01-base/playbook []
└─ #  cat inventory/prod.yml
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
  fed:
    hosts:
      fedora:
        ansible_connection: docker
 00:20:25 @ ~/netology/hw_ansible_ci_monitoring/08-ansible-01-base/playbook []
└─ #  cat group_vars/fed/examp.yml
---
  some_fact: "fedora default fact"
 00:20:36 @ ~/netology/hw_ansible_ci_monitoring/08-ansible-01-base/playbook []
└─ #  ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] **********************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************
ok: [ubuntu]
ok: [fedora]
ok: [centos7]
ok: [localhost]

TASK [Print OS] ****************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "CentOS"
}
ok: [fedora] => {
    "msg": "Fedora"
}

TASK [Print fact] **************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [fedora] => {
    "msg": "fedora default fact"
}

PLAY RECAP *********************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```
5. Cкрипт на bash: автоматизируем поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров. (Поскольку оригинальный образ Ubuntu, как оказалось не содержит python, необходимый для работы Ansible, то принято решение использовать неоригинальный образ (c Python3) из собственного Docker-registry). Также пароль для ansible-vault записан в файл `vault_pass.txt` для его использования с ansible-playbook.
```
 00:37:13 @ ~/netology/hw_ansible_ci_monitoring/08-ansible-01-base/playbook []
└─ #  cat script.sh
#!/bin/bash
docker run --rm -i --name centos7 -d centos:7
docker run --rm -i --name ubuntu -d evgenilistopad/ubuntu:python3
docker run --rm -i --name fedora -d fedora:38
docker ps
ansible-playbook -i inventory/prod.yml site.yml --vault-password-file vault_pass.txt
docker stop centos7
echo "is stopped"
docker stop ubuntu
echo "is stopped"
docker stop fedora
echo "is stopped"
 00:37:22 @ ~/netology/hw_ansible_ci_monitoring/08-ansible-01-base/playbook []
└─ #  cat vault_pass.txt
netology
```
6. Результат работы скрипта
```
 00:43:08 @ ~/netology/hw_ansible_ci_monitoring/08-ansible-01-base/playbook []
└─ #  ./script.sh
764e6b5565b5e153f2a270579aab7c03d687481f1a2fad451d95af697590cda1
a56798c3391124416c5a154f7f6d9ef80894ce9f8254dc105480045c812facda
25f125848a242697b58999182fd72658479c52ddfca40ed00648a37772a1795d
CONTAINER ID   IMAGE                           COMMAND       CREATED         STATUS                  PORTS     NAMES
25f125848a24   fedora:38                       "/bin/bash"   1 second ago    Up Less than a second             fedora
a56798c33911   evgenilistopad/ubuntu:python3   "bash"        1 second ago    Up Less than a second             ubuntu
764e6b5565b5   centos:7                        "/bin/bash"   2 seconds ago   Up 1 second                       centos7

PLAY [Print os facts] **********************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************
ok: [ubuntu]
ok: [fedora]
ok: [centos7]
ok: [localhost]

TASK [Print OS] ****************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "CentOS"
}
ok: [fedora] => {
    "msg": "Fedora"
}

TASK [Print fact] **************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [fedora] => {
    "msg": "fedora default fact"
}

PLAY RECAP *********************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

centos7
is stopped
ubuntu
is stopped
fedora
is stopped
```
7. Все изменения фиксируем и отправляем в [личный репозиторий](https://github.com/evgeni-listopad/devops-netology/tree/main/TASK_8.1).

