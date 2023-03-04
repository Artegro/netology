# Домашнее задание к занятию 5 «Тестирование roles»

## Подготовка к выполнению

1. Установите molecule: `python3 -m pip3 install "molecule==3.5.2"`.
2. Выполните `docker pull aragast/netology:latest` —  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри.

    Выполнено

## Основная часть

Ваша цель — настроить тестирование ваших ролей. 

Задача — сделать сценарии тестирования для vector. 

Ожидаемый результат — все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s centos7` внутри корневой директории clickhouse-role, посмотрите на вывод команды.
2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.

    Инициализируцем сценарий тестирования
    ```
    molecule init scenario default --driver-name docker
    INFO     Initializing new scenario default...
    INFO     Initialized scenario in /home/artegro/GitHub/HomeWork_8.5/roles/vector/molecule/default successfully.
    ```
    Далее добавляем в файл схемы ансибла meta.json следующую поддержку centos
    ```
     "CentOSPlatformModel": {
      "properties": {
        "name": {
          "const": "SCentOS",
          "title": "Name",
          "type": "string"
        },
        "versions": {
          "default": "all",
          "items": {
            "enum": ["6", "7", "8", "all"],
            "type": "string"
          },
          "type": "array"
        }
      },
      "title": "CentOSPlatformModel",
      "type": "object"
    },
    ```
    Запустим тест и проверим
    ```
    molecule test
    ...
    TASK [vector : VECTOR | Start service] *****************************************
    ok: [contos_7]

    TASK [vector : Flush handlers] *************************************************

    PLAY RECAP *********************************************************************
    contos_7                   : ok=5    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ...
    TASK [vector : Flush handlers] *************************************************

    PLAY RECAP *********************************************************************
    contos_7                   : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```
    Видим что иденпотентность есть . тест проходит

3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.

    Дописываем в molecule.yml  platphorm
    ```
    - name: contos_8
        image: pycontribs/centos:8
        pre_build_image: true
    - name: Ubuntu
        image: docker.io/library/ubuntu:latest
        pre_build_image: true
    ```

    Так как в contos 8 изначално проблема с репозиторием, дописываем в converge.yml pre_tasks
    ```
      pre_tasks:
    - name: Repository
      ansible.builtin.shell: |
        set -o pipefail;
        cd /etc/yum.repos.d/
        sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
        sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
        yum update -y
      ignore_errors: yes
      register: ignore_errors_register
      become: true
      changed_when: false
      args:
        executable: /bin/bash
      when: 
        - ansible_facts['distribution'] == 'CentOS'
        - ansible_distribution_major_version == "8"
    ```
    Проверяем
    ```
    molecule test
    ...
    PLAY RECAP *********************************************************************
    Ubuntu                     : ok=5    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
    centos_7                   : ok=5    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
    centos_8                   : ok=6    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=1   

    ...

    PLAY [Verify] ******************************************************************
    ...

    PLAY RECAP *********************************************************************
    Ubuntu                     : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    centos_7                   : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    centos_8                   : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    ```

4. Добавьте несколько assert в verify.yml-файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.). 

  Выпоним проверку
  ```
  PLAY RECAP *********************************************************************
  Ubuntu                     : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
  centos_7                   : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
  centos_8                   : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
  ```

5. Запустите тестирование роли повторно и проверьте, что оно прошло успешно.

  ```
  molecule test
  PLAY RECAP *********************************************************************
  localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
  ```
5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example).
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo — путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
6. Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.
8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Не забудьте указать в ответе теги решений Tox и Molecule заданий. В качестве решения пришлите ссылку на  ваш репозиторий и скриншоты этапов выполнения задания. 

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли LightHouse.
2. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
3. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
4. Выложите свои roles в репозитории.

В качестве решения пришлите ссылки и скриншоты этапов выполнения задания.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.
