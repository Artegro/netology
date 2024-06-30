# Дипломный практикум в Yandex.Cloud
  * [Цели:](#цели)
  * [Этапы выполнения:](#этапы-выполнения)
     * [Создание облачной инфраструктуры](#создание-облачной-инфраструктуры)
     * [Создание Kubernetes кластера](#создание-kubernetes-кластера)
     * [Создание тестового приложения](#создание-тестового-приложения)
     * [Подготовка cистемы мониторинга и деплой приложения](#подготовка-cистемы-мониторинга-и-деплой-приложения)
     * [Установка и настройка CI/CD](#установка-и-настройка-cicd)
  * [Что необходимо для сдачи задания?](#что-необходимо-для-сдачи-задания)
  * [Как правильно задавать вопросы дипломному руководителю?](#как-правильно-задавать-вопросы-дипломному-руководителю)

**Перед началом работы над дипломным заданием изучите [Инструкция по экономии облачных ресурсов](https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD).**

---
## Цели:

1. Подготовить облачную инфраструктуру на базе облачного провайдера Яндекс.Облако.
2. Запустить и сконфигурировать Kubernetes кластер.
3. Установить и настроить систему мониторинга.
4. Настроить и автоматизировать сборку тестового приложения с использованием Docker-контейнеров.
5. Настроить CI для автоматической сборки и тестирования.
6. Настроить CD для автоматического развёртывания приложения.

---
## Этапы выполнения:


### Создание облачной инфраструктуры

Для начала необходимо подготовить облачную инфраструктуру в ЯО при помощи [Terraform](https://www.terraform.io/).

Особенности выполнения:

- Бюджет купона ограничен, что следует иметь в виду при проектировании инфраструктуры и использовании ресурсов;
Для облачного k8s используйте региональный мастер(неотказоустойчивый). Для self-hosted k8s минимизируйте ресурсы ВМ и долю ЦПУ. В обоих вариантах используйте прерываемые ВМ для worker nodes.
- Следует использовать версию [Terraform](https://www.terraform.io/) не старше 1.5.x .

Предварительная подготовка к установке и запуску Kubernetes кластера.

1. Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными правами. Не стоит использовать права суперпользователя
2. Подготовьте [backend](https://www.terraform.io/docs/language/settings/backends/index.html) для Terraform:  
   а. Рекомендуемый вариант: S3 bucket в созданном ЯО аккаунте(создание бакета через TF)
   б. Альтернативный вариант:  [Terraform Cloud](https://app.terraform.io/)  
3. Создайте VPC с подсетями в разных зонах доступности.
4. Убедитесь, что теперь вы можете выполнить команды `terraform destroy` и `terraform apply` без дополнительных ручных действий.
5. В случае использования [Terraform Cloud](https://app.terraform.io/) в качестве [backend](https://www.terraform.io/docs/language/settings/backends/index.html) убедитесь, что применение изменений успешно проходит, используя web-интерфейс Terraform cloud.

Ожидаемые результаты:

1. Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий.
2. Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.

---

### Выполнение

1.   ### Подготовим для начала машину
    
*    Cтавим [terraform](https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip)     копикуем ахив, закидываем бинарник и немного разбираемся с правами, так как мы не ходим работать ихз под root-та версии 1.5.0  
    ![alt text](image.png) 

*   Далее [yc](https://yandex.cloud/ru/docs/cli/operations/install-cli) тут все просто , идем по инструкции
    ```
     curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash

    ```
    ![alt text](image-1.png)

*  Настроим и подготовим сервис аккаунт

   ![alt text](image-2.png)  
   Зону по умолчанию не ставим, в дальнейшем все ровно будем разносить в разные зоны все хосты.

   Создаем сервис аккаунт и назначим ему права
   ![alt text](image-3.png)  
   ![alt text](image-4.png)  
   Подготовим профиль для работы тераформа.  
   ![alt text](image-5.png)  
   ![alt text](image-6.png)  

   Установим переменные
   ```
      export YC_TOKEN=$(yc iam create-token)
      export YC_CLOUD_ID=$(yc config get cloud-id)
      export YC_FOLDER_ID=$(yc config get folder-id)
      export ACCESS_KEY="<идентификатор_ключа>"
      export SECRET_KEY="<секретный_ключ>"
   ```
   ![alt text](image-7.png)  
   ![alt text](image-8.png)  
   ![alt text](image-13.png)  
   ![alt text](image-12.png)  

   Создадим конфигурационный файл с содержимым
   ![alt text](image-9.png)  
   ```
   provider_installation {
      network_mirror {
         url = "https://terraform-mirror.yandexcloud.net/"
         include = ["registry.terraform.io/*/*"]
      }
      direct {
         exclude = ["registry.terraform.io/*/*"]
      }
   }
   ```
*  Перейдем к манифестам и подготовки инфраструктуры   

   Добавим тестово файл [Манифест](yc.tf) и выполним terraform init
   ![alt text](image-10.png)  
   ![alt text](image-11.png)  

   Создадим  с самими хранилищем для s3 [Манифест](s3-create.tf)
   далее запускаем и проверяем  
   ![alt text](image-14.png)  
   ![alt text](image-15.png)  
   ![alt text](image-16.png)  
   Проверяем в консоле yc что все появилось  
   ![alt text](image-24.png)  
   ![alt text](image-18.png) 

   Удалим, и то же проверим 
   ![alt text](image-20.png)  
   ![alt text](image-22.png)
   Проверяем в консоле yc что все появилось  
   ![alt text](image-21.png)  

   Видим что всё работает, Теперь еще раз создадим 
   ![alt text](image-23.png)  


   И далее применяем [Манифест](s3.tf) бакенд  
   ![alt text](image-17.png)  

   Проверяем в консоле yc что все появилось  
   ![alt text](image-18.png)  
   ![alt text](image-19.png)  

   Надо отметить, что как только мы перенесли бакенд в яндекс бакет, теперь при удалении бакет удаляться не будет, так как в нем теперь есть данные.


   Создаем [Манифест](vm.tf) с 3 ся виртуалками, для этого возьмем оманифест из прошлых домашек и слегка переделаем.  
   Заускаем и проверяем  
   ![alt text](image-25.png)  
   ![alt text](image-27.png)  
   ![alt text](image-28.png)  
   Обнаруживаем что 3-я машина не создалась, чутка гуглим и выясняем что в зоне d есть только стандарт v2 b v3 , правим файл и повторно запускаем  
   ![alt text](image-29.png)  
   В этот раз видим что всё создалось, проверяем в консоле  
   ![alt text](image-30.png)  
   ![alt text](image-31.png)  

   Теперь удаляем всё что понаделали чтоб не платить лишнего.
   ![alt text](image-32.png)  

   Видим что удалилось все кроме бакета  
   ![alt text](image-33.png)  

   Ну и в граф консоле  
   ![alt text](image-34.png)  


   На этом подготовительную часть можно закончить. 
### Создание Kubernetes кластера

На этом этапе необходимо создать [Kubernetes](https://kubernetes.io/ru/docs/concepts/overview/what-is-kubernetes/) кластер на базе предварительно созданной инфраструктуры.   Требуется обеспечить доступ к ресурсам из Интернета.

Это можно сделать двумя способами:

1. Рекомендуемый вариант: самостоятельная установка Kubernetes кластера.  
   а. При помощи Terraform подготовить как минимум 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера. Тип виртуальной машины следует выбрать самостоятельно с учётом требовании к производительности и стоимости. Если в дальнейшем поймете, что необходимо сменить тип инстанса, используйте Terraform для внесения изменений.  
   б. Подготовить [ansible](https://www.ansible.com/) конфигурации, можно воспользоваться, например [Kubespray](https://kubernetes.io/docs/setup/production-environment/tools/kubespray/)  
   в. Задеплоить Kubernetes на подготовленные ранее инстансы, в случае нехватки каких-либо ресурсов вы всегда можете создать их при помощи Terraform.
2. Альтернативный вариант: воспользуйтесь сервисом [Yandex Managed Service for Kubernetes](https://cloud.yandex.ru/services/managed-kubernetes)  
  а. С помощью terraform resource для [kubernetes](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster) создать **региональный** мастер kubernetes с размещением нод в разных 3 подсетях      
  б. С помощью terraform resource для [kubernetes node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group)
  
Ожидаемый результат:

1. Работоспособный Kubernetes кластер.
2. В файле `~/.kube/config` находятся данные для доступа к кластеру.
3. Команда `kubectl get pods --all-namespaces` отрабатывает без ошибок.

### Выполнение  

*  Мы жадные по этому идем по пути `yc cli` `terraform` `kubesray`, немного обращаемся к гуглу и находим замечателный [гайд](https://git.cloud-team.ru/lections/kubernetes_setup) возьмем его за основу которой пойдем переделав под себя. 

*  Добавим наш [бакет](s3.tf) в каталог с манифестами.  

*  От разбивки по разным манифестам в итоге отказался , посотянно выпалада ошибка на незадикларированные модули.  
   Правим [inventery](./kub/k8s-cluster.tf) меняем образ и колличество мастер нод.  
   ![alt text](image-36.png)  

   Колличество мастер нод и политику их пересоздания, по скольку нам не важна пока отказоустойчивость.  
   ![alt text](image-37.png)  

   Закидываем переменные для терраформа.  
   ![alt text](image-38.png)  

   И правим немного скрипт динамического инвентери для плейбука.  
   ![alt text](image-51.png)  
   ![alt text](image-50.png)  

   В переменных кластера `k8s-cluster.yml` меняем версию кубера и проверяем сетевой плангин.  
   ![alt text](image-42.png)  
   ![alt text](image-43.png)

   Далее скачаем и подготовим `kubesray`  [sprayget.sh](./kub/sprayget.sh).  
   Изменим зависимости в файле `requirements.txt`.  
   ![alt text](image-41.png)  

   Немного правим [скрипт](./kub/cluster_install.sh) установки кластера и заускаем.  

   ![alt text](image-40.png)

   И после получаса ожидания наблюдаем следующее.  
   ![alt text](image-44.png)

   Проверим в web консоле.  
   ![alt text](image-45.png)  
   ![alt text](image-46.png)

   Ну и в терминале.  
   ![alt text](image-47.png)  
   ![alt text](image-48.png)
   ![alt text](image-49.png)  

*  Проверили и теперь удалячем кластер.  
   Так же , чтьоб не писать руками команды используем скрипт.  
   ![alt text](image-52.png)  

   Запускаем.  
   ![alt text](image-53.png)
   ![alt text](image-54.png)  

   Проверяем, остался один бакет, как и говорил ранее , потому что там данные тераформа.  
   ![alt text](image-55.png) 




---
### Создание тестового приложения

Для перехода к следующему этапу необходимо подготовить тестовое приложение, эмулирующее основное приложение разрабатываемое вашей компанией.

Способ подготовки:

1. Рекомендуемый вариант:  
   а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.  
   б. Подготовьте Dockerfile для создания образа приложения.  
2. Альтернативный вариант:  
   а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.

Ожидаемый результат:

1. Git репозиторий с тестовым приложением и Dockerfile.
2. Регистри с собранным docker image. В качестве регистри может быть DockerHub или [Yandex Container Registry](https://cloud.yandex.ru/services/container-registry), созданный также с помощью terraform.

### Выполнение  

*  Позготовим файлы за образ пока берем стандарный конфиг по сути там менять нечего только заменить index.html [Dockerfile](./testapp/Dockerfile) [index.html](./testapp/index.html)  
   Создаем образ пушим в DockerHub и проверяем, развернем сразу в кластере [Манифест](./testapp/testapp.yml).   
   ![alt text](image-56.png)  
   ![alt text](image-57.png)  
   ![alt text](image-58.png)  

   Ну и в вебке по адресу балансировщика.  
   ![alt text](image-60.png)  
   ![alt text](image-59.png)


*  Все файлы и манифесты выше, [ссылка](https://hub.docker.com/r/agrod80/testapp) на репозиторий.

---
### Подготовка cистемы мониторинга и деплой приложения

Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.  
Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:
1. Задеплоить в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter) основных метрик Kubernetes.
2. Задеплоить тестовое приложение, например, [nginx](https://www.nginx.com/) сервер отдающий статическую страницу.

Способ выполнения:
1. Воспользовать пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus), который уже включает в себя [Kubernetes оператор](https://operatorhub.io/) для [grafana](https://grafana.com/), [prometheus](https://prometheus.io/), [alertmanager](https://github.com/prometheus/alertmanager) и [node_exporter](https://github.com/prometheus/node_exporter). При желании можете собрать все эти приложения отдельно.
2. Для организации конфигурации использовать [qbec](https://qbec.io/), основанный на [jsonnet](https://jsonnet.org/). Обратите внимание на имеющиеся функции для интеграции helm конфигов и [helm charts](https://helm.sh/)
3. Если на первом этапе вы не воспользовались [Terraform Cloud](https://app.terraform.io/), то задеплойте и настройте в кластере [atlantis](https://www.runatlantis.io/) для отслеживания изменений инфраструктуры. Альтернативный вариант 3 задания: вместо Terraform Cloud или atlantis настройте на автоматический запуск и применение конфигурации terraform из вашего git-репозитория в выбранной вами CI-CD системе при любом комите в main ветку. Предоставьте скриншоты работы пайплайна из CI/CD системы.

Ожидаемый результат:
1. Git репозиторий с конфигурационными файлами для настройки Kubernetes.
2. Http доступ к web интерфейсу grafana.
3. Дашборды в grafana отображающие состояние Kubernetes кластера.
4. Http доступ к тестовому приложению.

### Выполнение

*  Подготовим мониторинг.  

   Добавим репы и создадим новый namespace.  
   ![alt text](image-61.png)  

   Далее подготовим манифест для `helm` и ингрес.  
   ![alt text](image-62.png)
   ![alt text](image-63.png)    
   
   Так же правим немного ингрес для приложения и запускаем.  
   ![alt text](image-65.png)  
   ![alt text](image-64.png)   
   ![alt text](image-66.png)   

   Проверяем веб интерфейсы:  
   [Test](http://test.artegro.ru/)  
   [grafana](http://grafana.artegro.ru/)  
   login: admin
   password: lPa8R27IF6

   Ну и дашборд
   ![alt text](image-67.png)  

*  Git [репозиторий](https://github.com/Artegro/yc-infra/tree/main/infra) с настройкой кластера k8s.  
*  Сам [пайплайн](https://github.com/Artegro/yc-infra/blob/main/infra/.gitlab-ci.yml)
*  Ну и пример работы при коммите в ветку мейн  
   ![alt text](image-68.png)  

   Далее по шагам.  
   ![alt text](image-69.png)  

   ![alt text](image-70.png)  

   ![alt text](image-71.png)  

   ![alt text](image-72.png)

   Изменим состав кластера удалим один ингрес в манифесте `k8s-cluster.tf`.      
   ![alt text](image-74.png)   

   И в скрипте манифеста поменяем состав.  
   ![alt text](image-76.png)  
   ![alt text](image-75.png)  

   Сделаем коммит в ветку майн.

   ![alt text](image-77.png)

   Проверяем в консоли.  
   ![alt text](image-78.png)  

*  Коммит в ветку Test1 то же проходит, но изменения не применяются.  
   ![alt text](image-73.png)




---
### Установка и настройка CI/CD

Осталось настроить ci/cd систему для автоматической сборки docker image и деплоя приложения при изменении кода.

Цель:

1. Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.
2. Автоматический деплой нового docker образа.

Можно использовать [teamcity](https://www.jetbrains.com/ru-ru/teamcity/), [jenkins](https://www.jenkins.io/), [GitLab CI](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/) или GitHub Actions.

Ожидаемый результат:

1. Интерфейс ci/cd сервиса доступен по http.
2. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.
3. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистри, а также деплой соответствующего Docker образа в кластер Kubernetes.

###   Выполнение
Пункт 1 не совсем понял, надо выложить в доступ виртуалку с gitlab в которой делал ci cd ? 
Если учеть что это виртуалка у меня локальная...

*  Подготовиси пайплайн для приложения [.gitlab-ci](./appprod/.gitlab-ci.yml)

*  Сделаем коммит  и проверим.  
   ![alt text](image-79.png)  

   Образ собрался и залился в реджести, проверим что он обновился.
   ![alt text](image-80.png)  

*  Соджадим тег и проверим.
   ![alt text](image-81.png)  

   Сборка и деплой приложения прошел.  
   ![alt text](image-82.png)  

   Проверим репозиторий.
   ![alt text](image-84.png)

   Проверим что у нас собралось нужной версией приложения.
   ![alt text](image-83.png)



Еще раз дублирую ссылки на репозитории и феб интерфесы  
   [Test](http://test.artegro.ru/)   
   [grafana](http://grafana.artegro.ru/)   
   Git [репозиторий](https://github.com/Artegro/yc-infra/tree/main/infra) с настройкой кластера k8s.  
   Сам [пайплайн](https://github.com/Artegro/yc-infra/blob/main/infra/.gitlab-ci.yml) по разворачиванию инфраструктуры.  
   Пайплайн для приложения [.gitlab-ci](./appprod/.gitlab-ci.yml)
---
## Что необходимо для сдачи задания?

1. Репозиторий с конфигурационными файлами Terraform и готовность продемонстрировать создание всех ресурсов с нуля.
2. Пример pull request с комментариями созданными atlantis'ом или снимки экрана из Terraform Cloud или вашего CI-CD-terraform pipeline.
3. Репозиторий с конфигурацией ansible, если был выбран способ создания Kubernetes кластера при помощи ansible.
4. Репозиторий с Dockerfile тестового приложения и ссылка на собранный docker image.
5. Репозиторий с конфигурацией Kubernetes кластера.
6. Ссылка на тестовое приложение и веб интерфейс Grafana с данными доступа.
7. Все репозитории рекомендуется хранить на одном ресурсе (github, gitlab)
