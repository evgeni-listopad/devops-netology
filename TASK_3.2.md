# Домашнее задание к занятию "3.2. Работа в терминале, лекция 2"

1. Какого типа команда `cd`?

```bash
cd - это команда, встроенная в оболочку (cd is a shell builtin).
cd является встроенной командой, поскольку по своей функциональности она переключает текущую директорию, а по факту меняет переменные среды PWD и OLDPWD для текущей оболочки. 
Если бы cd была внешней командой, то она скорее всего была бы запущена в дочернем процессе (в оболочке, порожденной через fork нашей текущей оболочкой) 
и выполнила бы смену директории (через переменные среды) не для текущей оболочки, а для дочерней, что в свою очередь являлось бы не тем результатом работы, который мы ожидаем.
```

2. Какая альтернатива без pipe команде `grep <some_string> <some_file> | wc -l`?

```bash
grep -с <some_string> <some_file>
```

3. Какой процесс с PID `1` является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?

```bash
systemd(1)
```

4. Как будет выглядеть команда, которая перенаправит вывод stderr `ls` на другую сессию терминала?

Команда `ls test_file 2> /dev/pts/1`

```bash
vagrant@vagrant:~$ w
 20:54:53 up  1:48,  2 users,  load average: 0.00, 0.00, 0.00
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
vagrant  pts/0    10.0.2.2         19:07    2.00s  0.01s  0.00s w
vagrant  pts/1    10.0.2.2         20:53    8.00s  0.01s  0.01s -bash
vagrant@vagrant:~$ ls test_file 2> /dev/pts/1
```

5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл?
Да, получится например так `cat <file1 >file2`.
```bash
vagrant@vagrant:~$ echo test_info > file1
vagrant@vagrant:~$ cat <file1 >file2
vagrant@vagrant:~$ cat file2
test_info
```

6. Получится ли находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?
Да, получится например так `echo Hello world > /dev/tty4`, но наблюдать в графическом режиме не получиться, нужно переключиться в терминал `TTY4` (Ctrl-Alt-F4 в нашем случае)

7. Выполните команду `bash 5>&1`. К чему она приведет? Что будет, если вы выполните `echo netology > /proc/$$/fd/5`? Почему так происходит?
```bash
Команда bash 5>&1 создаст дескриптор с числом 5 и направит его в текущий stdout с дескриптором 1. 
vagrant@vagrant:~$ bash 5>&1
vagrant@vagrant:~$ echo netology > /proc/$$/fd/5
netology
Так происходит, потому что команда echo выводит свой stdout в дескриптор 5, 
который в свою очередь был перенаправлен в стандартный дескриптор 1, 
привязанный к текущему псевдотерминалу /dev/pts/0 (в нашем конкретном случае)
```

8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty?
Да, получится, но нужно поменять местами `stdout` и `stderr`, используя дополнительный дескриптор.
```bash
vagrant@vagrant:~$ ls -l file1 file2 6>&1 1>&2 2>&6 | grep -ci "no such file"
-rw-rw-r-- 1 vagrant vagrant 10 Jun 11 21:01 file1
1
```

9. Что выведет команда `cat /proc/$$/environ`? Как еще можно получить аналогичный по содержанию вывод?
```bash
Она выведет переменные среды в строку.
Можно воспользоваться командами env и printenv. они выведут список переменных среды построчно (каждая переменная в отдельной строке).
```

10. Используя `man`, опишите что доступно по адресам `/proc/<PID>/cmdline`, `/proc/<PID>/exe`?

```bash
/proc/<PID>/cmdline - в файле записана полная команда, которой был запущен процесс с идентификатором <PID>.
/proc/<PID>/exe - файл является символической ссылкой на исполняемый файл, которым был запущен процесс с идентификатором <PID>.
```

11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью `/proc/cpuinfo`.
```bash
cat /proc/cpuinfo | grep sse
Старшая версия SSE4.2 (Процессор Intel(R) Xeon(R) CPU E3-1230 V2)
```

12. При открытии нового окна терминала и `vagrant ssh` создается новая сессия и выделяется pty. Это можно подтвердить командой `tty`, которая упоминалась в лекции 3.2. Однако:

    ```bash
	vagrant@netology1:~$ ssh localhost 'tty'
	not a tty
    ```
Почитайте, почему так происходит, и как изменить поведение.
```bash
Ответ: Команда ssh <host> <command> не предполагает "заход" пользователя на удаленный хост, а лишь выполнение на удаленном хосте указанной команды. 
А раз не выполняется "заход", то и псевдотерминал создавать не нужно. Поэтому при выполнении ssh localhost 'tty' псевдотерминал не создается, 
соответственно команда 'tty' не может его найти и выдает 'not a tty'. 
Изменить поведение можно двумя способами:
1. Добавить к ssh опцию -t для принудительного создания псевдотерминала.
2. Выполнить команды по-отдельности: 'ssh localhost', 'tty', 'exit'.
```

13. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись `reptyr`.
```bash
vagrant@vagrant:~$ ps a
    PID TTY      STAT   TIME COMMAND
    660 tty1     Ss+    0:00 /sbin/agetty -o -p -- \u --noclear tty1 linux
  14036 pts/1    Ss     0:00 -bash
  14915 pts/0    Ss     0:00 -bash
  14926 pts/0    T      0:00 top
-------------------------------------------------
vagrant@vagrant:~/.ssh$ sudo reptyr -T 14926
```

14. `sudo echo string > /root/new_file` не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без `sudo` под вашим пользователем. Для решения данной проблемы можно использовать конструкцию `echo string | sudo tee /root/new_file`. Узнайте что делает команда `tee` и почему в отличие от `sudo echo` команда с `sudo tee` будет работать.
```bash
Команда tee читает стандартный поток stdin, отправляет его в stdout и копию его пишет в файл. 
Команда sudo tee будет работать, поскольку она открывает файл /root/new_file (из примера) с привилегированными sudo-правами. 
В случае с командой sudo echo string > /root/new_file файл будет открываться не командой echo  (запущенной с привилегированными правами), 
а текущей оболочкой, которая запущена от обычного непривилегированного пользователя. 
```
