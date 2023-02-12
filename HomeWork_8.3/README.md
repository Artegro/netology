# Домашнее задание к занятию "3. Использование Yandex Cloud"

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.

    Позготовим 3 ноды в Yandex Cloud.

Ссылка на репозиторий LightHouse: https://github.com/VKCOM/lighthouse

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает lighthouse.
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику lighthouse, установить nginx или любой другой webserver, настроить его конфиг для открытия lighthouse, запустить webserver.
4. Приготовьте свой собственный inventory файл `prod.yml`.

Ответ
```
```
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
    Готово

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

Запустим в флагом `--check`  к сожалению не может пройти дальше первой ноды, так как идет только проверка без установки.
```
ansible-playbook -vvv  -i inventory/prod.yml site.yml --check  -e 'ansible_python_interpreter=/usr/bin/python3'
...
...
PLAY RECAP ************************************************************************************************************************************************************************************************
clickhouse-01              : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=1    ignored=0  
```
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

Запускаем плейбук и видем что все проходит без ошибок
```
ansible-playbook -i inventory/prod.yml site.yml -e 'ansible_python_interpreter=/usr/bin/python3' --diff
...
...
PLAY RECAP ************************************************************************************************************************************************************************************************
clickhouse-01              : ok=6    changed=4    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
lighthouse-01              : ok=12   changed=8    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=6    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

Повторный запуск дает такой-же результать.
```
ansible-playbook -i inventory/prod.yml site.yml -e 'ansible_python_interpreter=/usr/bin/python3' --diff
...
...
PLAY RECAP ************************************************************************************************************************************************************************************************
clickhouse-01              : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
lighthouse-01              : ok=10   changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

Проверим что все работает  ClickHous
```
# ssh art@158.160.18.78
[art@clickhouse ~]$ clickhouse-client -h 127.0.0.1
ClickHouse client version 22.3.3.44 (official build).
Connecting to 127.0.0.1:9000 as user default.
Connected to ClickHouse server version 22.3.3 revision 54455.

```
Vector 
```
root@deb:~/.ssh# ssh art@158.160.9.53
[art@vector-01 ~]$ ls
[art@vector-01 ~]$ ls /home
art
[art@vector-01 ~]$ cat /etc/vector/vector.yml
sinks:
    to_clickhouse:
        compression: gzip
        database: logs
        endpoint: http://172.16.0.20:8123
        healthcheck: false
        inputs:
        - our_log
        skip_unknown_fields: true
        table: access_logs
        type: clickhouse
sources:
    our_log:
        ignore_older_secs: 600
        include:
        - /var/log/nginx/access.log
        read_from: beginning
        type: file
```
lighthouse
```
 ssh art@158.160.2.204
[art@lighthouse-01 ~]$
 sudo systemctl status nginx
* nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Sun 2023-02-12 12:41:53 UTC; 8min ago
  Process: 1366 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 1363 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
  Process: 1361 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 1368 (nginx)
   CGroup: /system.slice/nginx.service
           |-1368 nginx: master process /usr/sbin/nginx
           `-1369 nginx: worker process

Feb 12 12:41:53 lighthouse-01.ru-central1.internal systemd[1]: Starting The nginx HTTP and reverse proxy server...
Feb 12 12:41:53 lighthouse-01.ru-central1.internal nginx[1363]: nginx: [warn] server name "/var/log/nginx" has suspicious symbols in /etc/nginx/conf.d/default.conf:5
Feb 12 12:41:53 lighthouse-01.ru-central1.internal nginx[1363]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Feb 12 12:41:53 lighthouse-01.ru-central1.internal nginx[1363]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Feb 12 12:41:53 lighthouse-01.ru-central1.internal nginx[1366]: nginx: [warn] server name "/var/log/nginx" has suspicious symbols in /etc/nginx/conf.d/default.conf:5
Feb 12 12:41:53 lighthouse-01.ru-central1.internal systemd[1]: Started The nginx HTTP and reverse proxy server.
[art@lighthouse-01 ~]$ cat /etc/nginx/conf.d/default.conf
server {
    listen       80;
    server_name  localhost

    access_log  /var/log/nginx lighthouse_access.log  main;

    location / {
        root   /home/art/lighthouse;
        index  index.html;
    }
}
 ls /home/art/lighthouse
LICENSE  README.md  app.js  css  img  index.html  jquery.js  js

```
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

    [Readme.md] (https://github.com/Artegro/netology/blob/master/HomeWork_8.3/playbook/ReadMe.md)

10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
