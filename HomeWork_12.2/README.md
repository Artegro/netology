# Домашнее задание к занятию «Установка Kubernetes»

### Цель задания

Установить кластер K8s.

### Чеклист готовности к домашнему заданию

1. Развёрнутые ВМ с ОС Ubuntu 20.04-lts.


### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция по установке kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/).
2. [Документация kubespray](https://kubespray.io/).

-----

### Задание 1. Установить кластер k8s с 1 master node

1. Подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды.
2. В качестве CRI — containerd.
3. Запуск etcd производить на мастере.
4. Способ установки выбрать самостоятельно.

### Ответ

-   Подготовим ВМ 
    ![alt text](image.png)   
    
    node1  
    ![alt text](image-1.png)  

    node2  
    ![alt text](image-2.png)  

    node3  
    ![alt text](image-3.png)  

    node4  
    ![alt text](image-4.png)  

    node5  
    ![alt text](image-5.png)  

-   Устанавливаем `kubespray` на мастер ноду  

    Скачиваем репозиторий
    ![alt text](image-6.png)  

    Ставим зависимости и натыкаемся сразу на отсутствие pip3, исправляем  
    ![alt text](image-7.png)  
    ![alt text](image-8.png)  
    ...  
    ![alt text](image-9.png)  

    Готовим конфигурацию  
    ![alt text](image-10.png)  
    ![alt text](image-11.png)  
    ![alt text](image-12.png)  
    
    inventory.ini
    ![alt text](image-14.png) 
    
    host.yml  
    ![alt text](image-13.png)

    Запускаем  
    ```
    ansible-playbook -i inventory/mycluster/inventory.ini cluster.yml -b -vvv
    ```
    И неажиданно получаем ошибку  
    ![alt text](image-15.png)

    Подключаемся к одной из нод и видим, что у нас память не вся видна в гостевой системе.
    ![alt text](image-16.png) 

    Покопавшись в `этих ваших интернетах`, выясняется, что это поведение бывает с убунтой на некотором железе и Hyper-V, отрезается от выделеной памяти понрядка 200Мб, соответственно докидываем на ноды по 200Мб. и стартуем плейбук  
    Хотя так же можно поправить лимиты на 800 в пункте `minimal_node_memory_mb: 1024 ` в файле `roles/kubernetes/preinstall/defaults/main.yml`   
    ```
    ansible-playbook -i inventory/mycluster/inventory.ini cluster.yml -b -vvv
    ``` 
    И спустя `какое то время` ура!  
    ![alt text](image-17.png)  

    Переносим данные подключения к кластеру из `/etc/kubernetes/admin.conf`  в `/home/artegro/.kube/config`  
    Проверяем  
    ![alt text](image-19.png)

-   Возьмем [манифест](2.yml) из страной домашки и задеплоим его.  
    Видим, что все поды поднялись и распределились по всем рабочим нодам  
    ![alt text](image-18.png)  






## Дополнительные задания (со звёздочкой)

**Настоятельно рекомендуем выполнять все задания под звёздочкой.** Их выполнение поможет глубже разобраться в материале.   
Задания под звёздочкой необязательные к выполнению и не повлияют на получение зачёта по этому домашнему заданию. 

------
### Задание 2*. Установить HA кластер

1. Установить кластер в режиме HA.
2. Использовать нечётное количество Master-node.
3. Для cluster ip использовать keepalived или другой способ.

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl get nodes`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.