# Домашнее задание к занятию 9.4 «Jenkins»

## Подготовка к выполнению

1. Создать два VM: для jenkins-master и jenkins-agent.
2. Установить Jenkins при помощи playbook.
3. Запустить и проверить работоспособность.
4. Сделать первоначальную настройку.

### Результаты подготовки
* Созданные виртуальные машины:
[VMs](./TASK_9.4/VMs_9.4.JPG)
* Выполнение ansible-playbook:
```
19:20:08 @ ~/my-jenkins/infrastructure []
└─ #  ansible-playbook -i inventory/cicd/hosts.yml site.yml

PLAY [Preapre all hosts] *******************************************************

TASK [Gathering Facts] *********************************************************
ok: [jenkins-agent-01]
ok: [jenkins-master-01]

TASK [Create group] ************************************************************
changed: [jenkins-agent-01]
changed: [jenkins-master-01]

TASK [Create user] *************************************************************
changed: [jenkins-agent-01]
changed: [jenkins-master-01]

TASK [Install JDK] *************************************************************
changed: [jenkins-agent-01]
changed: [jenkins-master-01]

PLAY [Get Jenkins master installed] ********************************************

TASK [Gathering Facts] *********************************************************
ok: [jenkins-master-01]

TASK [Get repo Jenkins] ********************************************************
changed: [jenkins-master-01]

TASK [Add Jenkins key] *********************************************************
changed: [jenkins-master-01]

TASK [Install epel-release] ****************************************************
changed: [jenkins-master-01]

TASK [Install Jenkins and requirements] ****************************************
changed: [jenkins-master-01]

TASK [Ensure jenkins agents are present in known_hosts file] *******************
# 158.160.57.154:22 SSH-2.0-OpenSSH_7.4
# 158.160.57.154:22 SSH-2.0-OpenSSH_7.4
# 158.160.57.154:22 SSH-2.0-OpenSSH_7.4
changed: [jenkins-master-01] => (item=jenkins-agent-01)
[WARNING]: Module remote_tmp /home/jenkins/.ansible/tmp did not exist and was
created with a mode of 0700, this may cause issues when running as another
user. To avoid this, create the remote_tmp dir with the correct permissions
manually

TASK [Start Jenkins] ***********************************************************
changed: [jenkins-master-01]

PLAY [Prepare jenkins agent] ***************************************************

TASK [Gathering Facts] *********************************************************
ok: [jenkins-agent-01]

TASK [Add master publickey into authorized_key] ********************************
changed: [jenkins-agent-01]

TASK [Create agent_dir] ********************************************************
changed: [jenkins-agent-01]

TASK [Add docker repo] *********************************************************
changed: [jenkins-agent-01]

TASK [Install some required] ***************************************************
changed: [jenkins-agent-01]

TASK [Update pip] **************************************************************
changed: [jenkins-agent-01]

TASK [Install Ansible] *********************************************************
changed: [jenkins-agent-01]

TASK [Reinstall Selinux] *******************************************************
changed: [jenkins-agent-01]

TASK [Add local to PATH] *******************************************************
changed: [jenkins-agent-01]

TASK [Create docker group] *****************************************************
ok: [jenkins-agent-01]

TASK [Add jenkinsuser to dockergroup] ******************************************
changed: [jenkins-agent-01]

TASK [Restart docker] **********************************************************
changed: [jenkins-agent-01]

TASK [Install agent.jar] *******************************************************
changed: [jenkins-agent-01]

PLAY RECAP *********************************************************************
jenkins-agent-01           : ok=17   changed=14   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
jenkins-master-01          : ok=11   changed=9    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```
* Сделана первоначальная настройка:
[Jenkins_initial](./TASK_9.4/Jenkins_master_1.JPG)


## Основная часть

1. Сделать Freestyle Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
2. Сделать Declarative Pipeline Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
3. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`.
4. Создать Multibranch Pipeline на запуск `Jenkinsfile` из репозитория.
5. Создать Scripted Pipeline, наполнить его скриптом из [pipeline](./pipeline).
6. Внести необходимые изменения, чтобы Pipeline запускал `ansible-playbook` без флагов `--check --diff`, если не установлен параметр при запуске джобы (prod_run = True). По умолчанию параметр имеет значение False и запускает прогон с флагами `--check --diff`.
7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозиторий в файл `ScriptedJenkinsfile`.
8. Отправить ссылку на репозиторий с ролью и Declarative Pipeline и Scripted Pipeline.

### Выполнение основной части

* Сделана Freestyle Job, которая запускает `molecule test` из репозитория:
https://github.com/evgeni-listopad/vector-role

Применены следующие Bash-команды:

[Jenkins_Freestyle_Job](./TASK_9.4/Jenkins_master_4.JPG)

Запуск `molecule test` выполнен успешно:

[Jenkins_Freestyle_Job_result](./TASK_9.4/Jenkins_master_3.JPG)

* Сделана Declarative Pipeline Job. Обеспечена корректная ее работа при выполнении `molecule test`:

[Jenkins_Declarative_Job_result](./TASK_9.4/Jenkins_master_5.JPG)

* Содержимое Pipeline-скрипта перенесено в файл [Jenkinsfile](./TASK_9.4/Jenkinsfile)

* Создан Multibranch Pipeline на запуск `Jenkinsfile` из репозитория:

[Jenkins_Multibranch_Job_result](./TASK_9.4/Jenkins_master_6.JPG)

* Создан Scripted Pipeline и наполнен скриптом из задания.

[Jenkins_Scripted_Job](./TASK_9.4/Jenkins_master_8.JPG)

* Внесены изменения в pipeline в соотвествии с заданием, исправленный Pipeline вложен в репозиторий в файл [ScriptedJenkinsfile](./TASK_9.4/ScriptedJenkinsfile)

* Ссылки:
* [Репозиторий с ролью](https://github.com/evgeni-listopad/vector-role), на которой тестировались запуски `molecule test`.
* [Declarative Pipeline](./TASK_9.4/Jenkinsfile)
* [Scripted Pipeline](./TASK_9.4/ScriptedJenkinsfile)



