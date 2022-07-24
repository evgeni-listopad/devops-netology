# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | Никакое. Будет ошибка типов: unsupported operand type(s) for +: 'int' and 'str'  |
| Как получить для переменной `c` значение 12?  | Нужно привести переменную a к строковому типу: c=str(a)+b  |
| Как получить для переменной `c` значение 3?  | Нужно привести переменную b к числовому типу: c=a+int(b) |


## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Разъяснение:
```
1. Из скрипта убрана неиспользуемая переменная is_change.
2. Из скрипта убрана команда breake, которая прерывает обработку при первом же найденом вхождении.
3. В скрипта добавлена переменная target_path, определяющая путь к директории и обеспечивающая его вывод
вместе с именем файла, как требуется в задании.
```

### Мой скрипт:
```python
#!/usr/bin/env python3

import os

target_path = "/root/netology/sysadm-homeworks/"
bash_command = ["cd "+target_path, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(target_path+prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```
[root@cloneserv ~]# ./script.py
/root/netology/sysadm-homeworks/1.txt
/root/netology/sysadm-homeworks/2.txt
/root/netology/sysadm-homeworks/3.txt
/root/netology/sysadm-homeworks/4.txt
```


## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Разъяснение:
```
1. Подключаем модуль sys для работы с введенными аргументами.
2. Переменной target_path присваиваем значение текущей директории (по умолчанию, если скрипт запустили без аргументов).
3. Переменной target_path присваиваем значение введенного аргумента (если скрипт запустили с аргументом).
```

### Мой скрипт:
```python
#!/usr/bin/env python3

import os
import sys

target_path = os.getcwd()
if len(sys.argv)==2:
    target_path = sys.argv[1]
bash_command = ["cd "+target_path, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(target_path+prepare_result)

```

### Вывод скрипта при запуске при тестировании (с аргументом):
```
[root@cloneserv ~]# ./script.py ~/netology/sysadm-homeworks/
/root/netology/sysadm-homeworks/1.txt
/root/netology/sysadm-homeworks/2.txt
/root/netology/sysadm-homeworks/3.txt
/root/netology/sysadm-homeworks/4.txt
```

### Вывод скрипта при запуске при тестировании (без аргумента):
```
[root@cloneserv ~]# cd netology/sysadm-homeworks/
[root@cloneserv sysadm-homeworks]# ~/script.py
/root/netology/sysadm-homeworks1.txt
/root/netology/sysadm-homeworks2.txt
/root/netology/sysadm-homeworks3.txt
/root/netology/sysadm-homeworks4.txt
```


## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Мой скрипт:
```python
[root@cloneserv ~]# cat url_check.py
#!/usr/bin/env python3

import socket as s
import time as t
import datetime as d

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

print('********************')

# цикл для проверки изменения IP-адресов и вывода сообщения
while True :
  for host in srv:
    ip = s.gethostbyname(host)
    if ip != srv[host]:
      print(str(d.datetime.now().strftime("%Y-%m-%d %H:%M:%S")) +' [ERROR] ' + str(host) +' IP mistmatch: '+srv[host]+' '+ip)
      srv[host]=ip
  i+=1
  if i >= 200 :
    break
  t.sleep(wait)
```

### Вывод скрипта при запуске при тестировании:
```
[root@cloneserv ~]# ./url_check.py
*** start script ***
2022-08-06 22:41:06 drive.google.com - 172.217.16.14
2022-08-06 22:41:06 mail.google.com - 216.58.209.5
2022-08-06 22:41:06 google.com - 142.250.203.206
********************
2022-08-06 22:42:07 [ERROR] drive.google.com IP mistmatch: 172.217.16.14 142.250.203.206
2022-08-06 22:43:18 [ERROR] mail.google.com IP mistmatch: 216.58.209.5 216.58.215.101
2022-08-06 22:44:39 [ERROR] google.com IP mistmatch: 142.250.203.206 216.58.215.78
2022-08-06 22:45:10 [ERROR] drive.google.com IP mistmatch: 142.250.203.206 172.217.16.14
[root@cloneserv ~]#
```

