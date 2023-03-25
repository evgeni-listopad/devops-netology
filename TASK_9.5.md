# Домашнее задание к занятию 9.5 «Teamcity»

## Подготовка к выполнению

1. В Yandex Cloud создайте новый инстанс (4CPU4RAM) на основе образа `jetbrains/teamcity-server`.
2. Дождитесь запуска teamcity, выполните первоначальную настройку.
3. Создайте ещё один инстанс (2CPU4RAM) на основе образа `jetbrains/teamcity-agent`. Пропишите к нему переменную окружения `SERVER_URL: "http://<teamcity_url>:8111"`.
4. Авторизуйте агент.
5. Сделайте fork [репозитория](https://github.com/aragastmatb/example-teamcity).
6. Создайте VM (2CPU4RAM) и запустите [playbook](./infrastructure).

### Результаты подготовки
* Созданные виртуальные машины:
![VMs](./TASK_9.5/VMs_9.5.PNG)
* Выполнение ansible-playbook:
```
 21:16:39 @ ~/my-teamcity/infrastructure []
└─ #  ansible-playbook -i inventory/cicd/hosts.yml site.yml

PLAY [Get Nexus installed] *****************************************************

TASK [Gathering Facts] *********************************************************
ok: [nexus-01]

TASK [Create Nexus group] ******************************************************
changed: [nexus-01]

TASK [Create Nexus user] *******************************************************
changed: [nexus-01]

TASK [Install JDK] *************************************************************
changed: [nexus-01]

TASK [Create Nexus directories] ************************************************
changed: [nexus-01] => (item=/home/nexus/log)
changed: [nexus-01] => (item=/home/nexus/sonatype-work/nexus3)
changed: [nexus-01] => (item=/home/nexus/sonatype-work/nexus3/etc)
changed: [nexus-01] => (item=/home/nexus/pkg)
changed: [nexus-01] => (item=/home/nexus/tmp)

TASK [Download Nexus] **********************************************************
[WARNING]: Module remote_tmp /home/nexus/.ansible/tmp did not exist and was
created with a mode of 0700, this may cause issues when running as another
user. To avoid this, create the remote_tmp dir with the correct permissions
manually
changed: [nexus-01]

TASK [Unpack Nexus] ************************************************************
changed: [nexus-01]

TASK [Link to Nexus Directory] *************************************************
changed: [nexus-01]

TASK [Add NEXUS_HOME for Nexus user] *******************************************
changed: [nexus-01]

TASK [Add run_as_user to Nexus.rc] *********************************************
changed: [nexus-01]

TASK [Raise nofile limit for Nexus user] ***************************************
changed: [nexus-01]

TASK [Create Nexus service for SystemD] ****************************************
changed: [nexus-01]

TASK [Ensure Nexus service is enabled for SystemD] *****************************
changed: [nexus-01]

TASK [Create Nexus vmoptions] **************************************************
changed: [nexus-01]

TASK [Create Nexus properties] *************************************************
changed: [nexus-01]

TASK [Lower Nexus disk space threshold] ****************************************
skipping: [nexus-01]

TASK [Start Nexus service if enabled] ******************************************
changed: [nexus-01]

TASK [Ensure Nexus service is restarted] ***************************************
skipping: [nexus-01]

TASK [Wait for Nexus port if started] ******************************************
ok: [nexus-01]

PLAY RECAP *********************************************************************
nexus-01                   : ok=17   changed=15   unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
```
* Результат авторизации агента:
![Agent](./TASK_9.5/Agent.PNG)
* Адрес форка репозитория: https://github.com/evgeni-listopad/example-teamcity

## Основная часть

1. Создайте новый проект в teamcity на основе fork.
2. Сделайте autodetect конфигурации.
3. Сохраните необходимые шаги, запустите первую сборку master.
4. Поменяйте условия сборки: если сборка по ветке `master`, то должен происходит `mvn clean deploy`, иначе `mvn clean test`.
5. Для deploy будет необходимо загрузить `settings.xml` в набор конфигураций maven у teamcity, предварительно записав туда креды для подключения к nexus.
6. В pom.xml необходимо поменять ссылки на репозиторий и nexus.
7. Запустите сборку по master, убедитесь, что всё прошло успешно и артефакт появился в nexus.
8. Мигрируйте `build configuration` в репозиторий.
9. Создайте отдельную ветку `feature/add_reply` в репозитории.
10. Напишите новый метод для класса Welcomer: метод должен возвращать произвольную реплику, содержащую слово `hunter`.
11. Дополните тест для нового метода на поиск слова `hunter` в новой реплике.
12. Сделайте push всех изменений в новую ветку репозитория.
13. Убедитесь, что сборка самостоятельно запустилась, тесты прошли успешно.
14. Внесите изменения из произвольной ветки `feature/add_reply` в `master` через `Merge`.
15. Убедитесь, что нет собранного артефакта в сборке по ветке `master`.
16. Настройте конфигурацию так, чтобы она собирала `.jar` в артефакты сборки.
17. Проведите повторную сборку мастера, убедитесь, что сбора прошла успешно и артефакты собраны.
18. Проверьте, что конфигурация в репозитории содержит все настройки конфигурации из teamcity.
19. В ответе пришлите ссылку на репозиторий.

### Выполнение основной части
* Создан новый проект в teamcity на основе fork, сделан autodetect конфигурации:
![Autodetect](./TASK_9.5/Autodetect.PNG)
* Сохранены необходимые шаги, запущена первая сборка master:
![Steps](./TASK_9.5/Steps.PNG)
![Build_1](./TASK_9.5/Build_1.PNG)
* Изменены условия сборки (по ветке `master` или по другим веткам):
![Steps_2](./TASK_9.5/Steps_2.PNG)
* Изменен пароль на Nexus, корректный пароль записан в `settings.xml`. Файл `settings.xml` загружен в набор конфигураций maven:
![Settings](./TASK_9.5/Settings.PNG)
* Внесены изменения в [pom.xml](https://github.com/evgeni-listopad/example-teamcity/blob/master/pom.xml) для работы с запущенным в облаке Nexus.
* Запущена сборка по master. Всё прошло успешно, и артефакт появился в nexus:
![Art_1](./TASK_9.5/Art_1.PNG)
* Выполним миграцию `build configuration` в репозиторий, для этого в панели управления Teamcity Server / Projects / netology / Edit Project / Versioned Settings выберем Synchronization enabled и 
`VCS root: git@github.com:evgeni-listopad/example-teamcity.git#refs/heads/master`
* Создаем отдельную ветку `feature/add_reply` в репозитории:
![Branch](./TASK_9.5/Branch.PNG)
* Дописан новый метод для класса Welcomer:
```
public String sayNew(){
       return "This is a new text with a word hunter.";
}
```
```
System.out.println(welcomer.sayNew());
```
* Дополнен тест для нового метода на поиск слова `hunter`
```
@Test
public void welcomerSaysNew(){
        assertThat(welcomer.sayNew(), containsString("hunter"));
}
```
* Сделан push всех изменений в новую ветку `feature/add_reply` репозитория.
* Сборка самостоятельно запустилась, тесты прошли успешно:
![Build_2](./TASK_9.5/Build_2.PNG)

* Внесем изменения из произвольной ветки `feature/add_reply` в `master` через `Merge`:
![Pull_R1](./TASK_9.5/Pull_R1.PNG)
![Pull_R2](./TASK_9.5/Pull_R2.PNG)
![Pull_R3](./TASK_9.5/Pull_R3.PNG)
* Убеждаемся, что нет собранного артефакта в сборке по ветке `master`:
![Build_3](./TASK_9.5/Build_3.PNG)
* Настраиваем конфигурацию так, чтобы она собирала `.jar` в артефакты сборки:
![Art_2](./TASK_9.5/Art_2.PNG)
* Для инициирования повторной сборки обновим файл pom.xml, изменив в нем версию артефактов с `0.0.2` на `0.0.3`.
Проверяем, что сборка прошла успешно и артефакты собраны:
![Art_3](./TASK_9.5/Art_3.PNG)
* Также убеждаемся в наличии собранных артефактов в Nexus:
![Art_4](./TASK_9.5/Art_4.PNG)
* Убеждаемся, что конфигурация в репозитории содержит все настройки конфигурации из Teamcity. В частности вот эта [строка](https://github.com/evgeni-listopad/example-teamcity/blob/master/.teamcity/Netology/buildTypes/Netology_Build.xml#L7) содержит последнее изменение конфигурации, подразумевающее сохранение артефактов в Teamcity.
* [Cсылка на репозиторий](https://github.com/evgeni-listopad/example-teamcity)

