# Домашнее задание к занятию "7.1. Инфраструктура как код"

## Задача 1. Выбор инструментов. 
 
### Легенда
 
Через час совещание на котором менеджер расскажет о новом проекте. Начать работу над которым надо 
будет уже сегодня. 
На данный момент известно, что это будет сервис, который ваша компания будет предоставлять внешним заказчикам.
Первое время, скорее всего, будет один внешний клиент, со временем внешних клиентов станет больше.

Так же по разговорам в компании есть вероятность, что техническое задание еще не четкое, что приведет к большому
количеству небольших релизов, тестирований интеграций, откатов, доработок, то есть скучно не будет.  
   
Вам, как девопс инженеру, будет необходимо принять решение об инструментах для организации инфраструктуры.
На данный момент в вашей компании уже используются следующие инструменты: 
- остатки Сloud Formation, 
- некоторые образы сделаны при помощи Packer,
- год назад начали активно использовать Terraform, 
- разработчики привыкли использовать Docker, 
- уже есть большая база Kubernetes конфигураций, 
- для автоматизации процессов используется Teamcity, 
- также есть совсем немного Ansible скриптов, 
- и ряд bash скриптов для упрощения рутинных задач.  

Для этого в рамках совещания надо будет выяснить подробности о проекте, что бы в итоге определиться с инструментами:

1. Какой тип инфраструктуры будем использовать для этого проекта: изменяемый или не изменяемый?
1. Будет ли центральный сервер для управления инфраструктурой?
1. Будут ли агенты на серверах?
1. Будут ли использованы средства для управления конфигурацией или инициализации ресурсов? 
 
В связи с тем, что проект стартует уже сегодня, в рамках совещания надо будет определиться со всеми этими вопросами.


Если для ответа на эти вопросы недостаточно информации, то напишите какие моменты уточните на совещании.

### Решение задачи 1
1. Ответы на четыре вопроса, представленных в разделе "Легенда". 
- Какой тип инфраструктуры будем использовать для этого проекта: изменяемый или не изменяемый?
```
Изначально лучше запланировать неизменяемый тип инфраструктуры чтобы минимизировать дрейф конфигураций.
Однако, если в ходе совещания будет отмечена сложность поддержания такой инфраструктуры 
из-за необходимости крайне частой пересборки образов микросервисов, то можно на начальном этапе работы над проектом
использовать комбинированный или изменяемый тип инфраструктуры.
```
- Будет ли центральный сервер для управления инфраструктурой?
```
На начальном этапе можно работать и без центрального сервера, а далее по мере роста сложности проекта 
принимать решение о целесообразности использования центрального сервера или отказоустойчивого кластера таких серверов. 
```
- Будут ли агенты на серверах?
```
Если говорить об управлении инфраструктурой, то в агентах не будет необходимости 
при использовании agentless-продуктов типа Ansible и Terraform.
Если говорить о средствах мониторинга (Zabbix, Prometheus, Ganglia), то агенты на серверах нужны для сбора метрик.  
```
- Будут ли использованы средства для управления конфигурацией или инициализации ресурсов?
```
Да, без этого сложно. Целесообразно использовать связку Ansible и Terraform.
```
2. Какие инструменты из уже используемых вы хотели бы использовать для нового проекта? 
```
Для подготовки образов - Packer.
Для инициализации ресурсов - Terraform.
Для управления конфигурациями - Ansible.
Для оркестрации микросервисов - Docker и Kubernetes.
```
3. Хотите ли рассмотреть возможность внедрения новых инструментов для этого проекта? 
```
Да. Рассмотрел бы возможность развертывания корпоративного GitLab (в том числе для Docker-registry, CI/CD).
Возможно использовал бы Zabbix для мониторинга всей ИТ-инфраструктуры предприятия
(в том числе сетевые и силовые устройства). 
Также присмотрелся бы к инструменту Foreman (упоминали на лекции).
```

## Задача 2. Установка терраформ. 

Официальный сайт: https://www.terraform.io/

Установите терраформ при помощи менеджера пакетов используемого в вашей операционной системе.
В виде результата этой задачи приложите вывод команды `terraform --version`.

### Решение задачи 2
```
 01:16:05 @ ~/terraform []
└─ #  terraform --version
Terraform v1.3.3
on linux_amd64
```

## Задача 3. Поддержка легаси кода. 

В какой-то момент вы обновили терраформ до новой версии, например с 0.12 до 0.13. 
А код одного из проектов настолько устарел, что не может работать с версией 0.13. 
В связи с этим необходимо сделать так, чтобы вы могли одновременно использовать последнюю версию терраформа установленную при помощи
штатного менеджера пакетов и устаревшую версию 0.12. 

В виде результата этой задачи приложите вывод `--version` двух версий терраформа доступных на вашем компьютере 
или виртуальной машине.

### Решение задачи 3
```
 01:12:09 @ ~/terraform []
└─ #  wget https://releases.hashicorp.com/terraform/0.12.0/terraform_0.12.0_linux_amd64.zip
--2022-10-28 01:12:45--  https://releases.hashicorp.com/terraform/0.12.0/terraform_0.12.0_linux_amd64.zip
Resolving releases.hashicorp.com (releases.hashicorp.com)... 18.66.233.74, 18.66.233.22, 18.66.233.2, ...
Connecting to releases.hashicorp.com (releases.hashicorp.com)|18.66.233.74|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 14907580 (14M) [application/zip]
Saving to: ‘terraform_0.12.0_linux_amd64.zip’

terraform_0.12.0_linux_a 100%[===============================>]  14.22M  7.16MB/s    in 2.0s

2022-10-28 01:12:48 (7.16 MB/s) - ‘terraform_0.12.0_linux_amd64.zip’ saved [14907580/14907580]

 01:16:38 @ ~/terraform []
└─ #  unzip terraform_0.12.0_linux_amd64.zip
Archive:  terraform_0.12.0_linux_amd64.zip
  inflating: terraform
 01:17:02 @ ~/terraform []
└─ #  cp terraform /usr/local/bin/terraform_0.12.0
 01:17:40 @ ~/terraform []
└─ #
 01:17:41 @ ~/terraform []
└─ #  terraform
terraform         terraform_0.12.0  terraform_1.2.8
 01:17:41 @ ~/terraform []
└─ #  terraform_0.12.0 --version
Terraform v0.12.0

Your version of Terraform is out of date! The latest version
is 1.3.3. You can update by downloading from www.terraform.io/downloads.html
```