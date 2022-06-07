# Домашнее задание к занятию "3.1. Работа в терминале, лекция 1"
1. Установите средство виртуализации Oracle VirtualBox.
Установлено в Windows 10

2. Установите средство автоматизации Hashicorp Vagrant.
Установлено в Windows 10

3. В вашем основном окружении подготовьте удобный для дальнейшей работы терминал.
Выбран Windows Terminal

4. Запустите Ubuntu 20.04 в VirtualBox посредством Vagrant.
Запуск был выполнен командами:
C:\HashiCorp\Vagrant\folder>c:\HashiCorp\Vagrant\bin\vagrant.exe box add bentoo/ubuntu-20.04 C:\Users\Admin\Downloads\Ubuntu
C:\HashiCorp\Vagrant\folder>c:\HashiCorp\Vagrant\bin\vagrant.exe bentoo/ubuntu-20.04 init
C:\HashiCorp\Vagrant\folder>c:\HashiCorp\Vagrant\bin\vagrant.exe bentoo/ubuntu-20.04 up

5. Какие ресурсы выделены по-умолчанию?
Оперативная память 1024 МБ
Процессоры: 2
Виртуальный размер носителя: 64 ГБ
Порядок загрузки: жесткий диск, оптический диск
Адаптер 1: NAT

6. Как добавить оперативной памяти или ресурсов процессора виртуальной машине?
В конфигурационном файле Vagrantfile скорректировать параметры в блоке:
config.vm.provider "virtualbox" do |v|
  v.memory = 1024
  v.cpus = 2
end

8.1. какой переменной можно задать длину журнала history, и на какой строчке manual это описывается?
HISTFILESIZE (line 846/4548)
HISTSIZE (line 862/4548)

8.2. что делает директива ignoreboth в bash?
ignoreboth это сокращение для двух директив: ignorespace и ignoredups, где 
    ignorespace - не сохранять команды, начинающиеся с пробела;
    ignoredups - не сохранять команду, если она уже есть в истории.

9. { list; } используется для подстановки элементов из списка
(line 257/4548)

10.1.  С учётом ответа на предыдущий вопрос, как создать однократным вызовом touch 100000 файлов?
touch {1..100000}

10.2. Получится ли аналогичным образом создать 300000? Если нет, то почему?
Нет, пишет, что слишком длинный список указан в качестве аргумента.

11. Что делает конструкция [[ -d /tmp ]]?
Проверяет, есть ли в файловой системе директория /tmp. Если она есть - код возврата 0, если ее нет - код возврата 1.

12. Добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке
vagrant@vagrant:~$ mkdir /tmp/new_path_dir/
vagrant@vagrant:~$ cp /bin/bash /tmp/new_path_dir/
vagrant@vagrant:~$ PATH=/tmp/new_path_dir/:$PATH
vagrant@vagrant:~$ type -a bash
bash is /tmp/new_path_dir/bash
bash is /usr/bin/bash
bash is /bin/bash

13. Чем отличается планирование команд с помощью batch и at?
at - команда запускается в указанное в аргументе время
batch - запускается когда уровень загрузки системы (load average) снизится ниже 1.5.

