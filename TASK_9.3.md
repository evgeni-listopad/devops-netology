# Домашнее задание к занятию 9.3 «Процессы CI/CD»

## Подготовка к выполнению

1. Создайте два VM в Yandex Cloud с параметрами: 2CPU 4RAM Centos7 (остальное по минимальным требованиям).
2. Пропишите в [inventory](./infrastructure/inventory/cicd/hosts.yml) [playbook](./infrastructure/site.yml) созданные хосты.
3. Добавьте в [files](./infrastructure/files/) файл со своим публичным ключом (id_rsa.pub). Если ключ называется иначе — найдите таску в плейбуке, которая использует id_rsa.pub имя, и исправьте на своё.
4. Запустите playbook, ожидайте успешного завершения.
5. Проверьте готовность SonarQube через [браузер](http://localhost:9000).
6. Зайдите под admin\admin, поменяйте пароль на свой.
7.  Проверьте готовность Nexus через [бразуер](http://localhost:8081).
8. Подключитесь под admin\admin123, поменяйте пароль, сохраните анонимный доступ.

### Результаты подготовки
* Созданные виртуальные машины:
[VMs](./TASK_9.3/VMs.jpg)
* Выполнение ansible-playbook:
```
 03:29:22 @ ~/mnt-homeworks/mnt-homeworks/09-ci-03-cicd/infrastructure [MNT-video]
└─ #  ansible-playbook -i inventory/cicd/hosts.yml site.yml

PLAY [Get OpenJDK installed] ***************************************************

TASK [Gathering Facts] *********************************************************
ok: [sonar-01]

--------------------------------------------------------------------------------
--------------------------------ВЫВОД ПРОПУЩЕН----------------------------------
--------------------------------------------------------------------------------

PLAY [Get Nexus installed] *****************************************************

TASK [Gathering Facts] *********************************************************
ok: [nexus-01]

--------------------------------------------------------------------------------
--------------------------------ВЫВОД ПРОПУЩЕН----------------------------------
--------------------------------------------------------------------------------

PLAY RECAP *********************************************************************
nexus-01                   : ok=17   changed=15   unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
sonar-01                   : ok=35   changed=27   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
* Готовность SonarQube:
[Sonar](./TASK_9.3/Sonar.jpg)
* Готовность Nexus:
[Nexus](./TASK_9.3/Nexus.jpg)

## Знакомоство с SonarQube

### Основная часть

1. Создайте новый проект, название произвольное.
2. Скачайте пакет sonar-scanner, который вам предлагает скачать SonarQube.
3. Сделайте так, чтобы binary был доступен через вызов в shell (или поменяйте переменную PATH, или любой другой, удобный вам способ).
4. Проверьте `sonar-scanner --version`.
5. Запустите анализатор против кода из директории [example](./example) с дополнительным ключом `-Dsonar.coverage.exclusions=fail.py`.
6. Посмотрите результат в интерфейсе.
7. Исправьте ошибки, которые он выявил, включая warnings.
8. Запустите анализатор повторно — проверьте, что QG пройдены успешно.
9. Сделайте скриншот успешного прохождения анализа, приложите к решению ДЗ.

### Результаты работы с SonarQube
* Создаем проект с названием `Netology`.
* Устанавливаем и настраиваем последнюю версию `sonar-scanner`:
```
 20:29:37 @ ~/hw []
└─ #  sonar-scanner --version
INFO: Scanner configuration file: /root/hw/sonar/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: SonarScanner 4.8.0.2856
INFO: Java 11.0.17 Eclipse Adoptium (64-bit)
INFO: Linux 5.19.6-1.el8.elrepo.x86_64 amd64
```
* Запускаем анализатор кода:
```
 20:55:42 @ ~/hw/sonar/example []
└─ #  sonar-scanner \
>   -Dsonar.projectKey=Netology \
>   -Dsonar.sources=. \
>   -Dsonar.host.url=http://51.250.72.121:9000 \
>   -Dsonar.login=5caa9f7bbd1a3930ed14bf1a46e85291bcb14389 \
>   -Dsonar.coverage.exclusions=fail.py
INFO: Scanner configuration file: /root/hw/sonar/conf/sonar-scanner.properties
--------------------------------------------------------------------------------
--------------------------------ВЫВОД ПРОПУЩЕН----------------------------------
--------------------------------------------------------------------------------
INFO: ANALYSIS SUCCESSFUL, you can browse http://51.250.72.121:9000/dashboard?id=Netology
INFO: Note that you will be able to access the updated dashboard once the server has processed the submitted analysis report
INFO: More about the report processing at http://51.250.72.121:9000/api/ce/task?id=AYbcHr83ngF0ReACzw1m
INFO: Analysis total time: 7.428 s
INFO: ------------------------------------------------------------------------
INFO: EXECUTION SUCCESS
INFO: ------------------------------------------------------------------------
INFO: Total time: 1:09.653s
INFO: Final Memory: 7M/27M
INFO: ------------------------------------------------------------------------
```
* Смотрим результат в интерфейсе:
[Before_fix](./TASK_9.3/Before_fix.jpg)
* Исправляем ошибки, запускаем `sonar-scanner` повторно и смотрим результат в интерфейсе:
[After_fix](./TASK_9.3/After_fix.jpg)

## Знакомство с Nexus

### Основная часть

1. В репозиторий `maven-public` загрузите артефакт с GAV-параметрами:

 *    groupId: netology;
 *    artifactId: java;
 *    version: 8_282;
 *    classifier: distrib;
 *    type: tar.gz.
   
2. В него же загрузите такой же артефакт, но с version: 8_102.
3. Проверьте, что все файлы загрузились успешно.
4. В ответе пришлите файл `maven-metadata.xml` для этого артефекта.

### Результаты работы с Nexus

* Результаты загрузки артефактов с версиями 8_282 и 8_102:
[Nexus_OK](./TASK_9.3/Nexus_OK.jpg)
* Файл [maven-metadata.xml](./TASK_9.3/maven-metadata.xml) для загруженных артефактов.

## Знакомство с Maven

### Подготовка к выполнению

1. Скачайте дистрибутив с [maven](https://maven.apache.org/download.cgi).
2. Разархивируйте, сделайте так, чтобы binary был доступен через вызов в shell (или поменяйте переменную PATH, или любой другой, удобный вам способ).
3. Удалите из `apache-maven-<version>/conf/settings.xml` упоминание о правиле, отвергающем HTTP- соединение — раздел mirrors —> id: my-repository-http-unblocker.
4. Проверьте `mvn --version`.
5. Заберите директорию `mvn` с pom.

### Результаты подготовки к выполнению задания с Maven

* Для работы с `maven` потребовалась установка и минимальная настройка `java`. Результат установки:
```
 22:04:57 @ ~/hw/java []
└─ #  java --version
openjdk 13.0.1 2019-10-15
OpenJDK Runtime Environment (build 13.0.1+9)
OpenJDK 64-Bit Server VM (build 13.0.1+9, mixed mode, sharing)
```
* Выполнена установка и настройка `apache-maven-3.9.0`:
```
 22:05:19 @ ~/hw/java []
└─ #  mvn --version
Apache Maven 3.9.0 (9b58d2bad23a66be161c4664ef21ce219c2c8584)
Maven home: /root/hw/maven
Java version: 13.0.1, vendor: Oracle Corporation, runtime: /root/hw/java
Default locale: en_US, platform encoding: UTF-8
OS name: "linux", version: "5.19.6-1.el8.elrepo.x86_64", arch: "amd64", family: "unix"
```

### Основная часть

1. Поменяйте в `pom.xml` блок с зависимостями под ваш артефакт из первого пункта задания для Nexus (java с версией 8_282).
2. Запустите команду `mvn package` в директории с `pom.xml`, ожидайте успешного окончания.
3. Проверьте директорию `~/.m2/repository/`, найдите ваш артефакт.
4. В ответе пришлите исправленный файл `pom.xml`.

### Результаты выполнения основной части по Maven
* Скорректирован файл `pom.xml` для работы с пользовательским артефактом из первого пункта задания для Nexus (java с версией 8_282).
* Сокращенный результат запуска `mvn package` в директории с `pom.xml`:
```
 22:12:53 @ ~/hw/maven/mvn []
└─ #  mvn package
[INFO] Scanning for projects...
[INFO]
[INFO] --------------------< com.netology.app:simple-app >---------------------
[INFO] Building simple-app 1.0-SNAPSHOT
[INFO]   from pom.xml
[INFO] --------------------------------[ jar ]---------------------------------
Downloading from central: https://repo.maven.apache.org/maven2/org/apache/maven/plugins/maven-resources-plugin/3.3.0/maven-resources-plugin-3.3.0.pom
-------------------------------------------------------------------------------
--------------------------------ВЫВОД ПРОПУЩЕН---------------------------------
-------------------------------------------------------------------------------
Downloaded from central: https://repo.maven.apache.org/maven2/org/apache/commons/commons-compress/1.21/commons-compress-1.21.jar (1.0 MB at 3.1 MB/s)
[WARNING] JAR will be empty - no content was marked for inclusion!
[INFO] Building jar: /root/hw/maven/mvn/target/simple-app-1.0-SNAPSHOT.jar
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  12.135 s
[INFO] Finished at: 2023-03-13T22:14:05+03:00
[INFO] ------------------------------------------------------------------------
 22:14:05 @ ~/hw/maven/mvn []
└─ #
```
* Проверка директории `~/.m2/repository/`. Убеждаемся в наличии пользовательского артефакта:
```
 22:17:31 @ ~/hw/maven/mvn []
└─ #  ll ~/.m2/repository/netology/java/8_282/
total 16
-rw-r--r-- 1 root root 835 Mar 13 22:13 java-8_282-distrib.tar.gz
-rw-r--r-- 1 root root  40 Mar 13 22:13 java-8_282-distrib.tar.gz.sha1
-rw-r--r-- 1 root root 390 Mar 13 22:13 java-8_282.pom.lastUpdated
-rw-r--r-- 1 root root 175 Mar 13 22:13 _remote.repositories
 22:17:42 @ ~/hw/maven/mvn []
└─ #
```
* Исправленный файл [pom.xml](./TASK_9.3/pom.xml)

