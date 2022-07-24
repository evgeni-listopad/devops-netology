# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"

## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```json
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

### Ошибки в строках 5, 6, 9. Необходимо поставить недостающие кавычки в строках 5 и 9, а также запятую в строке 6:
```bash
[root@host ~]# cat -n 1.json
     1      { "info" : "Sample JSON output from our service\t",
     2          "elements" :[
     3              { "name" : "first",
     4              "type" : "server",
     5              "ip" : "7175"
     6              },
     7              { "name" : "second",
     8              "type" : "proxy",
     9              "ip" : "71.78.22.43"
    10              }
    11          ]
    12      }
```

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Мой скрипт:
```python
[root@host ~]# cat url_check_new.py
#!/usr/bin/env python3

import socket as s
import time as t
import datetime as d
import json
import yaml

# установка переменных
i = 1
wait = 2 # интервал проверок в секундах
srv = {'drive.google.com':'0.0.0.0', 'mail.google.com':'0.0.0.0', 'google.com':'0.0.0.0'}
print('*** start script ***')

# первичная инициализация IP-адресов и их вывод в требуемом формате
for host in srv:
    ip = s.gethostbyname(host)
    srv[host]=ip
    print(str(d.datetime.now().strftime("%Y-%m-%d %H:%M:%S")) + ' ' + str(host) +' - '+ ip)
# json

with open("log.json",'w') as js_log:
    js_data = json.dumps(srv)
    js_log.write(js_data)
with open("log.yaml",'w') as yaml_log:
    yaml_data = yaml.dump(srv, default_flow_style=False)
    yaml_log.write(yaml_data)

print('********************')

# цикл для проверки изменения IP-адресов и вывода сообщения
while True :
  for host in srv:
    ip = s.gethostbyname(host)
    if ip != srv[host]:
      print(str(d.datetime.now().strftime("%Y-%m-%d %H:%M:%S")) +' [ERROR] ' + str(host) +' IP mistmatch: '+srv[host]+' '+ip)
      srv[host]=ip
      with open("log.json",'w') as js_log:
        js_data = json.dumps(srv)
        js_log.write(js_data)
      with open("log.yaml",'w') as yaml_log:
        yaml_data = yaml.dump(srv)
        yaml_log.write(yaml_data, default_flow_style=False)
    i+=1
  if i >= 100 :
    break
  t.sleep(wait)
```


### Вывод скрипта при запуске при тестировании:
```
[root@host ~]# ./url_check_new.py
*** start script ***
2022-08-07 05:13:36 drive.google.com - 142.250.186.206
2022-08-07 05:13:36 mail.google.com - 216.58.209.5
2022-08-07 05:13:36 google.com - 142.250.203.206
********************
2022-08-07 05:14:38 [ERROR] google.com IP mistmatch: 142.250.203.206 172.217.16.46
2022-08-07 05:15:03 [ERROR] drive.google.com IP mistmatch: 142.250.186.206 172.217.16.14
```

### json-файл(ы), который(е) записал скрипт:
```json
[root@host ~]# cat log.json
{"drive.google.com": "172.217.16.14", "mail.google.com": "216.58.209.5", "google.com": "172.217.16.46"}
```

### yml-файл(ы), который(е) записал скрипт:
```yaml
[root@host ~]# cat log.yaml
drive.google.com: 172.217.16.14
google.com: 172.217.16.46
mail.google.com: 216.58.209.5
```

