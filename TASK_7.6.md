# Домашнее задание к занятию "7.6. Написание собственных провайдеров для Terraform."

Бывает, что 
* общедоступная документация по терраформ ресурсам не всегда достоверна,
* в документации не хватает каких-нибудь правил валидации или неточно описаны параметры,
* понадобиться использовать провайдер без официальной документации,
* может возникнуть необходимость написать свой провайдер для системы используемой в ваших проектах.   

## Задача 1. 
Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда: 
[https://github.com/hashicorp/terraform-provider-aws.git](https://github.com/hashicorp/terraform-provider-aws.git).
Просто найдите нужные ресурсы в исходном коде и ответы на вопросы станут понятны.  


1. Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на 
гитхабе.   
1. Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`. 
    * С каким другим параметром конфликтует `name`? Приложите строчку кода, в которой это указано.
    * Какая максимальная длина имени? 
    * Какому регулярному выражению должно подчиняться имя? 
    
### Решение задачи 1.
- Доступные ресурсы описаны в структуре `ResourcesMap: map[string]*schema.Resource` файла `provider.go`.
По состоянию на 12.11.2022 это строка [941](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L941)
- Доступные источники данных описаны в структуре `DataSourcesMap: map[string]*schema.Resource` файла `provider.go`.
По состоянию на 12.11.2022 это строка [421](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L421)
- Конфликт `name` по-видимому указан в строке `ConflictsWith: []string{"name_prefix"}` файла `queue.go`.
По состоянию на 12.11.2022 это строка [88](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L88)
```
		"name": {
			Type:          schema.TypeString,
			Optional:      true,
			Computed:      true,
			ForceNew:      true,
			ConflictsWith: []string{"name_prefix"},
		},
```
- Максимальная длина имени - 80 символов, указана в строке ``re = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,80}$`)`` файла `queue.go`. По состоянию на 12.11.2022 это строка [433](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L433)
```
		if fifoQueue {
			re = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,75}\.fifo$`)
		} else {
			re = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,80}$`)
		}
```
- Имя должно подчиняться регулярному выражению ``re = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,80}$`)`` файла `queue.go`. По состоянию на 12.11.2022 это строка [433](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L433)


## Задача 2. (Не обязательно) 
В рамках вебинара и презентации мы разобрали как создать свой собственный провайдер на примере кофемашины. 
Также вот официальная документация о создании провайдера: 
[https://learn.hashicorp.com/collections/terraform/providers](https://learn.hashicorp.com/collections/terraform/providers).

1. Проделайте все шаги создания провайдера.
2. В виде результата приложение ссылку на исходный код.
3. Попробуйте скомпилировать провайдер, если получится то приложите снимок экрана с командой и результатом компиляции.   

### Решение задачи 2.
- Запускаем Docker-контейнеры скаченного с [GitHub](https://github.com/hashicorp/learn-terraform-hashicups-provider) инстанса HashiCups:
```
 22:07:52 @ ~/my-terraform []
└─ #  cd learn-terraform-hashicups-provider/docker_compose/
 22:07:53 @ ~/my-terraform/learn-terraform-hashicups-provider/docker_compose [main]
└─ #  docker compose up
```
- Проверяем доступность:
```
 22:15:52 @ ~ []
└─ #  curl localhost:19090/health
ok
```
- Скачиваем исходные коды hashicups-provider:
```
 22:17:50 @ ~/my-terraform []
└─ #  git clone https://github.com/hashicorp/terraform-provider-hashicups
Cloning into 'terraform-provider-hashicups'...
..............................................
```
- Заходим в директорию и устанавливаем все зависимости для сборки провайдера:
```
 22:18:37 @ ~/my-terraform []
└─ #  cd terraform-provider-hashicups
 22:20:47 @ ~/my-terraform/terraform-provider-hashicups [main]
└─ #  go mod tidy
go: downloading github.com/hashicorp/terraform-plugin-sdk/v2 v2.23.0
.............ВЫВОД ОПУЩЕН.........................
go: downloading github.com/Microsoft/go-winio v0.4.16
```
- Выполняем сборку провайдера:
```
 22:23:49 @ ~/my-terraform/terraform-provider-hashicups [main]
└─ #  go build -o terraform-provider-hashicups
```
- Создаем plugins-поддиректорию и помещаем туда собранный бинарный файл провайдера
```
 22:24:41 @ ~/my-terraform/terraform-provider-hashicups [main]
└─ #  mkdir -p ~/.terraform.d/plugins/hashicorp.com/edu/hashicups/0.3.1/linux_amd64   22:30:31 @ ~/my-terraform/terraform-provider-hashicups [main]
└─ #  mv terraform-provider-hashicups ~/.terraform.d/plugins/hashicorp.com/edu/hashicups/0.3.1/linux_amd64
```
- Создаем пользователя `netology`:
```
 22:30:53 @ ~/my-terraform/terraform-provider-hashicups [main]
└─ #  curl -X POST localhost:19090/signup -d '{"username":"netology", "password":"test123"}'
{"UserID":1,"Username":"netology","token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NjgzNjc5NDcsInVzZXJfaWQiOjEsInVzZXJuYW1lIjoibmV0b2xvZ3kifQ.jldT_kHKBpCt3zhD9DmxqMleDwzTMr2X05mz-Mg0P5s"}
```
- Выполняем аутентификацию в HashiCups:
```
 22:32:27 @ ~/my-terraform/terraform-provider-hashicups [main]
└─ #  curl -X POST localhost:19090/signin -d '{"username":"netology", "password":"test123"}'
{"UserID":1,"Username":"netology","token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NjgzNjgwOTUsInVzZXJfaWQiOjEsInVzZXJuYW1lIjoibmV0b2xvZ3kifQ.fS6OWgDwDD44nGJSV7GeFRYZIrC7s0ToFjJJIqEHrKA"}
```
- Сохраняем полученный token в переменной окружения:
```
 22:34:55 @ ~/my-terraform/terraform-provider-hashicups [main]
└─ #  export HASHICUPS_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NjgzNjgwOTUsInVzZXJfaWQiOjEsInVzZXJuYW1lIjoibmV0b2xvZ3kifQ.fS6OWgDwDD44nGJSV7GeFRYZIrC7s0ToFjJJIqEHrKA
```
- Создадим файл `main.tf`:
```
 22:39:53 @ ~/my-terraform/terraform-provider-hashicups [main]
└─ #  cat main.tf
terraform {
  required_providers {
    hashicups = {
      version = "~> 0.3.1"
      source  = "hashicorp.com/edu/hashicups"
    }
  }
}

provider "hashicups" {
  username = "netology"
  password = "test123"
}

resource "hashicups_order" "edu" {
  items {
    coffee {
      id = 3
    }
    quantity = 2
  }
  items {
    coffee {
      id = 2
    }
    quantity = 2
  }
}

output "edu_order" {
  value = hashicups_order.edu
}

```
- Инициализируем Terraform с указанием директории с локальными plugin'ами, где находится custom-провайдер:
```
 23:31:58 @ ~/my-terraform/learn-terraform-hashicups-provider [main]
└─ #  terraform init -plugin-dir=/root/.terraform.d/plugins/

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp.com/edu/hashicups versions matching "~> 0.3.1"...
- Installing hashicorp.com/edu/hashicups v0.3.1...
- Installed hashicorp.com/edu/hashicups v0.3.1 (unauthenticated)

Terraform has made some changes to the provider dependency selections recorded
in the .terraform.lock.hcl file. Review those changes and commit them to your
version control system if they represent changes you intended to make.

╷
│ Warning: Incomplete lock file information for providers
│
│ Due to your customized provider installation methods, Terraform was forced to
│ calculate lock file checksums locally for the following providers:
│   - hashicorp.com/edu/hashicups
│
│ The current .terraform.lock.hcl file only includes checksums for linux_amd64, so
│ Terraform running on another platform will fail to install these providers.
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
 23:32:04 @ ~/my-terraform/learn-terraform-hashicups-provider [main]
└─ #
```
- Применяем изменения Terraform:
```
 23:35:17 @ ~/my-terraform/learn-terraform-hashicups-provider [main]
└─ #  terraform apply --auto-approve

Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # hashicups_order.edu will be created
  + resource "hashicups_order" "edu" {
      + id           = (known after apply)
      + last_updated = (known after apply)

      + items {
          + quantity = 2

          + coffee {
              + description = (known after apply)
              + id          = 3
              + image       = (known after apply)
              + name        = (known after apply)
              + price       = (known after apply)
              + teaser      = (known after apply)
            }
        }
      + items {
          + quantity = 2

          + coffee {
              + description = (known after apply)
              + id          = 2
              + image       = (known after apply)
              + name        = (known after apply)
              + price       = (known after apply)
              + teaser      = (known after apply)
            }
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + edu_order = {
      + id           = (known after apply)
      + items        = [
          + {
              + coffee   = [
                  + {
                      + description = (known after apply)
                      + id          = 3
                      + image       = (known after apply)
                      + name        = (known after apply)
                      + price       = (known after apply)
                      + teaser      = (known after apply)
                    },
                ]
              + quantity = 2
            },
          + {
              + coffee   = [
                  + {
                      + description = (known after apply)
                      + id          = 2
                      + image       = (known after apply)
                      + name        = (known after apply)
                      + price       = (known after apply)
                      + teaser      = (known after apply)
                    },
                ]
              + quantity = 2
            },
        ]
      + last_updated = (known after apply)
    }
hashicups_order.edu: Creating...
hashicups_order.edu: Creation complete after 0s [id=1]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

edu_order = {
  "id" = "1"
  "items" = tolist([
    {
      "coffee" = tolist([
        {
          "description" = ""
          "id" = 3
          "image" = "/nomad.png"
          "name" = "Nomadicano"
          "price" = 150
          "teaser" = "Drink one today and you will want to schedule another"
        },
      ])
      "quantity" = 2
    },
    {
      "coffee" = tolist([
        {
          "description" = ""
          "id" = 2
          "image" = "/vault.png"
          "name" = "Vaulatte"
          "price" = 200
          "teaser" = "Nothing gives you a safe and secure feeling like a Vaulatte"
        },
      ])
      "quantity" = 2
    },
  ])
  "last_updated" = tostring(null)
}
```
- Проверяем, что заказ создался:
```
 23:39:27 @ ~/my-terraform/learn-terraform-hashicups-provider [main]
└─ #  curl -X GET  -H "Authorization: ${HASHICUPS_TOKEN}" localhost:19090/orders/1 | jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   396  100   396    0     0  66000      0 --:--:-- --:--:-- --:--:-- 66000
{
  "id": 1,
  "items": [
    {
      "coffee": {
        "id": 3,
        "name": "Nomadicano",
        "teaser": "Drink one today and you will want to schedule another",
        "description": "",
        "price": 150,
        "image": "/nomad.png",
        "ingredients": null
      },
      "quantity": 2
    },
    {
      "coffee": {
        "id": 2,
        "name": "Vaulatte",
        "teaser": "Nothing gives you a safe and secure feeling like a Vaulatte",
        "description": "",
        "price": 200,
        "image": "/vault.png",
        "ingredients": null
      },
      "quantity": 2
    }
  ]
}
```
- Исходные коды [здесь](https://github.com/evgeni-listopad/devops-netology/tree/main/TASK_7.6_)
- Снимок экрана с командой и результатом компиляции:
![Compilation](img/Compilation.png)

