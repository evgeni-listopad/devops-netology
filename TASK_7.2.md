# Домашнее задание к занятию "7.2. Облачные провайдеры и синтаксис Terraform."

Зачастую разбираться в новых инструментах гораздо интересней понимая то, как они работают изнутри. 
Поэтому в рамках первого *необязательного* задания предлагается завести свою учетную запись в AWS (Amazon Web Services) или Yandex.Cloud.
Идеально будет познакомится с обоими облаками, потому что они отличаются. 

## Задача 1 (Вариант с Yandex.Cloud). Регистрация в ЯО и знакомство с основами (необязательно, но крайне желательно).

1. Подробная инструкция на русском языке содержится [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
2. Обратите внимание на период бесплатного использования после регистрации аккаунта. 
3. Используйте раздел "Подготовьте облако к работе" для регистрации аккаунта. Далее раздел "Настройте провайдер" для подготовки
базового терраформ конфига.
4. Воспользуйтесь [инструкцией](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs) на сайте терраформа, что бы 
не указывать авторизационный токен в коде, а терраформ провайдер брал его из переменных окружений.

### Решение задачи 1
- Подготавливаем облако к работе, устанавливаем и настраиваем утилиту yc. Результат настройки утилиты:
```
 23:30:33 @ ~/terraform/task7.2 []
└─ #  yc config list
token: y0_.......................CN
cloud-id: b1gkjk5reuc4u9svu54m
folder-id: b1gj45vv7fpc7kmc184h
compute-default-zone: ru-central1-a
```
- Прописываем переменные среды, чтобы не указывать авторизационный токен и идентификаторы в коде:
```
 23:31:14 @ ~/terraform/task7.2 []
└─ #  export YC_TOKEN=$(yc iam create-token)
 23:36:23 @ ~/terraform/task7.2 []
└─ #  export YC_CLOUD_ID=$(yc config get cloud-id)
 23:36:23 @ ~/terraform/task7.2 []
└─ #  export YC_FOLDER_ID=$(yc config get folder-id)
 23:36:23 @ ~/terraform/task7.2 []
└─ #  export YC_ZONE=$(yc config get compute-default-zone)
```
- Создаем в домашней директории пользователя файл .terraformrc с данными зеркала репозитория:
```
 23:37:31 @ ~/terraform/task7.2 []
└─ #  cat ~/.terraformrc
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```
- Создаем файл provider.tf с данными о провайдере
```
 23:40:38 @ ~/terraform/task7.2 []
└─ #  cat provider.tf
# Provider
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}
```
- Инициализируем terraform для работы с провайдером:
```
 23:46:01 @ ~/terraform/task7.2 []
└─ #  terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of yandex-cloud/yandex...
- Installing yandex-cloud/yandex v0.81.0...
- Installed yandex-cloud/yandex v0.81.0 (unauthenticated)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

╷
│ Warning: Incomplete lock file information for providers
│
│ Due to your customized provider installation methods, Terraform was forced to calculate
│ lock file checksums locally for the following providers:
│   - yandex-cloud/yandex
│
│ The current .terraform.lock.hcl file only includes checksums for linux_amd64, so Terraform
│ running on another platform will fail to install these providers.
│
│ To calculate additional checksums for another platform, run:
│   terraform providers lock -platform=linux_amd64
│ (where linux_amd64 is the platform to generate)
╵

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
 23:46:17 @ ~/terraform/task7.2 []
└─ #
```

## Задача 2. Создание aws ec2 или yandex_compute_instance через терраформ. 

1. В каталоге `terraform` вашего основного репозитория, который был создан в начале курсе, создайте файл `main.tf` и `versions.tf`.
2. Зарегистрируйте провайдер 
   1. для [aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs). В файл `main.tf` добавьте
   блок `provider`, а в `versions.tf` блок `terraform` с вложенным блоком `required_providers`. Укажите любой выбранный вами регион 
   внутри блока `provider`.
   2. либо для [yandex.cloud](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs). Подробную инструкцию можно найти 
   [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
3. Внимание! В гит репозиторий нельзя пушить ваши личные ключи доступа к аккаунту. Поэтому в предыдущем задании мы указывали
их в виде переменных окружения. 
4. В файле `main.tf` воспользуйтесь блоком `data "aws_ami` для поиска ami образа последнего Ubuntu.  
5. В файле `main.tf` создайте рессурс 
   1. либо [ec2 instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance).
   Постарайтесь указать как можно больше параметров для его определения. Минимальный набор параметров указан в первом блоке 
   `Example Usage`, но желательно, указать большее количество параметров.
   2. либо [yandex_compute_image](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_image).
6. Также в случае использования aws:
   1. Добавьте data-блоки `aws_caller_identity` и `aws_region`.
   2. В файл `outputs.tf` поместить блоки `output` с данными об используемых в данный момент: 
       * AWS account ID,
       * AWS user ID,
       * AWS регион, который используется в данный момент, 
       * Приватный IP ec2 инстансы,
       * Идентификатор подсети в которой создан инстанс.  
7. Если вы выполнили первый пункт, то добейтесь того, что бы команда `terraform plan` выполнялась без ошибок. 


В качестве результата задания предоставьте:
1. Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?
1. Ссылку на репозиторий с исходной конфигурацией терраформа.  
 
### Решение задачи 2
- При помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?
```
Ответ: Packer.
```
- Формируем файл  main.tf с информацией о создаваемых ресурсах:
```
 23:51:35 @ ~/terraform/task7.2 []
└─ #  cat main.tf
resource "yandex_compute_instance" "node-task" {
  name                      = "node-task"
  zone                      = "ru-central1-a"
  hostname                  = "node-task7.2.netology.cloud"
  allow_stopping_for_update = true

  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.centos}"
      name        = "root-node-task"
      type        = "network-nvme"
      size        = "50"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.default.id}"
    nat       = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}

variable "centos" {
  default = "fd8j0db3lnmi4g7k93u5"
}

resource "yandex_vpc_network" "default" {
  name = "net"
}

resource "yandex_vpc_subnet" "default" {
  name = "subnet"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["192.168.101.0/24"]
}
```
- Формируем файл output.tf с информацией о выводимых значениях IP-адресов созданной виртуальной машины:
```
 23:54:18 @ ~/terraform/task7.2 []
└─ #  cat output.tf
output "internal_ip_address_node-task_yandex_cloud" {
  value = "${yandex_compute_instance.node-task.network_interface.0.ip_address}"
}

output "external_ip_address_node-task_yandex_cloud" {
  value = "${yandex_compute_instance.node-task.network_interface.0.nat_ip_address}"
}
```
- Проверяем конфигурацию terraform:
```
 23:55:42 @ ~/terraform/task7.2 []
└─ #  ls
main.tf  output.tf  provider.tf
 23:55:44 @ ~/terraform/task7.2 []
└─ #  terraform validate
Success! The configuration is valid.
```
- Готовим план и применяем terraform:
```
 23:56:08 @ ~/terraform/task7.2 []
└─ #  terraform plan

---------------------ВЫВОД ОПУЩЕН ------------------------------------------

 23:56:59 @ ~/terraform/task7.2 []
└─ #  terraform apply --auto-approve

---------------------ВЫВОД ОПУЩЕН ------------------------------------------

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_node-task_yandex_cloud = "51.250.9.224"
internal_ip_address_node-task_yandex_cloud = "192.168.101.18"
```
- Проверяем созданную виртуальную машину:
```
 00:01:17 @ ~/terraform/task7.2 []
└─ #  yc compute instance list
+----------------------+-----------+---------------+---------+--------------+----------------+
|          ID          |   NAME    |    ZONE ID    | STATUS  | EXTERNAL IP  |  INTERNAL IP   |
+----------------------+-----------+---------------+---------+--------------+----------------+
| fhm20gguv33d9e6vpin7 | node-task | ru-central1-a | RUNNING | 51.250.9.224 | 192.168.101.18 |
+----------------------+-----------+---------------+---------+--------------+----------------+

 00:01:19 @ ~/terraform/task7.2 []
└─ #  ssh centos@51.250.9.224
The authenticity of host '51.250.9.224 (51.250.9.224)' can't be established.
ECDSA key fingerprint is SHA256:nVOQ6sBvo89BgDsKS2/qOHe73e6P+ws1cEowonRqugs.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '51.250.9.224' (ECDSA) to the list of known hosts.
[centos@node-task7 ~]$
[centos@node-task7 ~]$ exit
logout
Connection to 51.250.9.224 closed.
 00:02:21 @ ~/terraform/task7.2 []
└─ #
```
- Освобождаем ресурсы в Yandex-cloud:
```
 00:02:21 @ ~/terraform/task7.2 []
└─ #  terraform destroy --auto-approve
yandex_vpc_network.default: Refreshing state... [id=enpv7upj93hp40qcvmhv]
yandex_vpc_subnet.default: Refreshing state... [id=e9b3hpqc8bvbgq50ru83]
yandex_compute_instance.node-task: Refreshing state... [id=fhm20gguv33d9e6vpin7]

---------------------ВЫВОД ОПУЩЕН ------------------------------------------

Destroy complete! Resources: 3 destroyed.
```
- [Ссылка на репозиторий для текущего задания](https://github.com/evgeni-listopad/devops-netology/tree/main/TASK_7.2)



