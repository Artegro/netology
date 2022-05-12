# Домашнее задание к занятию "6.1. Типы и структура СУБД"

## Задача 1

Архитектор ПО решил проконсультироваться у вас, какой тип БД 
лучше выбрать для хранения определенных данных.

Он вам предоставил следующие типы сущностей, которые нужно будет хранить в БД:

- Электронные чеки в json виде  
Ответ:
```
Для этой задачи NoSQL Документо-ориентированные, в ней наиболее подходящая структура для хранение json объектов 
(каждый документ представляет собой набор json значений)
```

- Склады и автомобильные дороги для логистической компании  
Ответ:
```
NoSQL Графовые , тут мы склады обозначаем как объекты а дороги как ребра соединяющие эти склады . 
```

- Генеалогические деревья  
Ответ:
```
NoSQL  Иерархические , древовидная структура готовое дерево . просто заполняй данные.
```

- Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации  
Ответ:
```
NoSQL Ключ-значение , в тиакой базе , храним кеш, где например ключ это имя пользователя а значение это его кеш, сам размер и состав кеша может быть разным. 
```

- Отношения клиент-покупка для интернет-магазина  
Ответ:
```
NoSQL Документо-ориентированные, каждый заказ это документ json в базе. простота хранения и получения данных
```

Выберите подходящие типы СУБД для каждой сущности и объясните свой выбор.

## Задача 2

Вы создали распределенное высоконагруженное приложение и хотите классифицировать его согласно 
CAP-теореме. Какой классификации по CAP-теореме соответствует ваша система, если 
(каждый пункт - это отдельная реализация вашей системы и для каждого пункта надо привести классификацию):

- Данные записываются на все узлы с задержкой до часа (асинхронная запись)  
Ответ:
```
AP
```
- При сетевых сбоях, система может разделиться на 2 раздельных кластера  
Ответ:
```
AP
```
- Система может не прислать корректный ответ или сбросить соединение  
Ответ:
```
CP
```

А согласно PACELC-теореме, как бы вы классифицировали данные реализации?  
Ответ:
```
1 PAEL
2 PAEL
3 PCEC
```

## Задача 3

Могут ли в одной системе сочетаться принципы BASE и ACID? Почему?  
Ответ:
```
Могут , но в  хороших условиях , когда нет высоких нагрузок (загрузка системы , запросы и т.д.) и сбоев оборудования.
В этом случае бд по модели BASE  успевают обрабатывать транзакции и расходжения данных не происходит.
```
## Задача 4

Вам дали задачу написать системное решение, основой которого бы послужили:

- фиксация некоторых значений с временем жизни
- реакция на истечение таймаута  
Ответ:
```
Беру ответ из лекции Redis , "Может использоваться как БД, так и как кэш-система или брокер
сообщений" "Данным можно присваивать Time-To-Live."  
То есть можем хранить значения указывая им время жизни, что нам и надо.
```
Вы слышали о key-value хранилище, которое имеет механизм [Pub/Sub](https://habr.com/ru/post/278237/). 
Что это за система? Какие минусы выбора данной системы?  
Ответ:
```
И опять Redis , система где  есть Издатель и подпищики , при чем подписчиков может и не быть.
Издатели создают сообщения, система (pub-sub) их отправляет, а подпищики обрабатываю сообщения.
Минусы.. это смотря для чего использовать эту систему. Скорее всего не надо её использовать для хранения накладных или например наменклатуры склада,
а вот для примера выше само то видимо, возможно какой то кеш с временем жизни. 
```
---