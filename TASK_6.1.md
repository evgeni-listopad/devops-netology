# Домашнее задание к занятию "6.1. Типы и структура СУБД"

## Задача 1

Архитектор ПО решил проконсультироваться у вас, какой тип БД 
лучше выбрать для хранения определенных данных.

Он вам предоставил следующие типы сущностей, которые нужно будет хранить в БД:

- Электронные чеки в json виде
- Склады и автомобильные дороги для логистической компании
- Генеалогические деревья
- Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации
- Отношения клиент-покупка для интернет-магазина

Выберите подходящие типы СУБД для каждой сущности и объясните свой выбор.

### Решение задачи 1
```
1) Электронные чеки в json виде.
Для документов в виде json оптимально использовать документо-ориентированную СУБД (например, MongoDB)
2) Склады и автомобильные дороги для логистической компании.
При данном описании структуру можно представить как множество узлов и множество связей между ними.
Для этого подходит сетевая (когда дочерний узел может иметь несколько родителей) или графовая СУБД.
3) Генеалогические деревья.
Оптимально использовать иерархическую СУБД с формированием отдельного экземпляра для каждого дерева,
но можно также использовать и реляционную.
4) Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутентификации.
Очень похоже на СУБД типа "ключ:значение", так как они зачастую применяются для реализации кэшей.
Можно использовать например Redis или Memcached.
5) Отношения клиент-покупка для интернет-магазина.
В данном случае можно использовать классическую реляционную СУБД, в которой будут реализованы 
отношения многие ко многим (клиенты <--> товары). 
Также можно рассмотреть объектно-ориентированную СУБД, где объектом будет выступать конкретная покупка,
для которой будет храниться информация о клиенте и товаре, а также другие необходимые сведения.
```

## Задача 2

Вы создали распределенное высоконагруженное приложение и хотите классифицировать его согласно 
CAP-теореме. Какой классификации по CAP-теореме соответствует ваша система, если 
(каждый пункт - это отдельная реализация вашей системы и для каждого пункта надо привести классификацию):

- Данные записываются на все узлы с задержкой до часа (асинхронная запись)
- При сетевых сбоях, система может разделиться на 2 раздельных кластера
- Система может не прислать корректный ответ или сбросить соединение

А согласно PACELC-теореме, как бы вы классифицировали данные реализации?

### Решение задачи 2
```
1) Данные записываются на все узлы с задержкой до часа (асинхронная запись).
Поскольку данные все же записываются, то присутствует availability.
Поскольку запись идет асинхронно, то отсутствует consistency.
Соответственно получается, что система AP.
По классификации PACELC: PA-EL (наиболее доступная),
также возможно PС-EL (согласованная со ставкой на доступность).
2) При сетевых сбоях, система может разделиться на 2 раздельных кластера.
Раз при сбоях система распадается на 2 раздельных кластера,
то у системы отсутствует partition tolerance.
Соответственно получается, что система CA.
По классификации PACELC: PС-EL (согласованная со ставкой на доступность) 
либо PA-EC (доступная со ставкой на согласованность).
3) Система может не прислать корректный ответ или сбросить соединение.
В системе, очевидно, отсутствует availability.
Соответственно получается, что система CP.
По классификации PACELC: PC-EC (наиболее согласованная),
также возможно PA-EC (доступная со ставкой на согласованность).
```

## Задача 3

Могут ли в одной системе сочетаться принципы BASE и ACID? Почему?

### Решение задачи 3
```
Принципы BASE и ACID не могут сочетаться в одной системе.
ACID обеспечивает согласованность системы, в то время как BASE фокусируется на высокой доступности данных.
ACID позволяет проектировать высоконадежные системы, BASE - высокопроизводительные.
Если у системы достаточно аппаратных ресурсов, то может сложиться впечатление, 
что в системе сочетаются принципы BASE и ACID (всё производительно и надежно), однако, если 
система начинает испытывать дефицит ресурсов, то проявится только один из принципов (либо BASE, либо ACID).
```

## Задача 4

Вам дали задачу написать системное решение, основой которого бы послужили:

- фиксация некоторых значений с временем жизни
- реакция на истечение таймаута

Вы слышали о key-value хранилище, которое имеет механизм [Pub/Sub](https://habr.com/ru/post/278237/). 
Что это за система? Какие минусы выбора данной системы?

### Решение задачи 4
```
Согласно материалам вебинара и приведенной статьи Key-value хранилищем с поддержкой механизма Pub/Sub 
является система Redis. Pub/sub — это механизм, который позволяет, с одной стороны, подписаться на канал 
и получать сообщения из него, с другой стороны — отправлять в этот канал сообщение, которое будет 
получено всеми подписчиками.
Минусами выбора такой системы будут следующие:
- Данные в момент работы хранятся в оперативной памяти, поэтому максимальный ее объем зависит от 
аппаратных возможностей физической машины. Также в случае отказа машины, все данные СУБД Redis, которые 
накопились в оперативной памяти с момента последней синхронизации с диском, будут утеряны.  
- Система репликации Redis сама по себе не поддерживает автоматическую отказоустойчивость: 
если ведущий узел выходит из строя, необходимо вручную выбрать нового ведущего среди ведомых узлов; 
но имеется система Redis Sentinel, обеспечивающая мониторинг и автоматическое переключение.
- Redis является NoSQL-системой, соответственно у неё отсутствует доступ к данным средствами языка SQL.
```
