# Playbook из файлы site.yml
- Данный playbook устанавливает ClickHouse, Vector и lighthouse на хостах описаных в /inventory/prod.yml , в данном случае это хосты поднятые в Yandex Cloud, но обращение к ним идет как к обычному хосту по ssh использу ssh key установленный в control node под пользователем из под которого запскается playbook.
- Inventory используется /inventory/prod.yml

# Параметры и переменные
### Параментры: 
- тип коннекторов подключения к nodes,
        |ansible_host| IP address to connect node|
        |ansible_user| User name to connect node|
### Переменные соответственно в каталоге '/group_vars/"hosts name"/vars.yml' в нашем случае это версии пакетов, параметры подключения, адреса с репозитарием и данные пользователей подключения.

- В папке /group_vars/all переменнывй применяемые для всех хостов , в наше случае это переменные для clickhouse логин и пароль.
        
        --------------
        |vars|description|
        |----------|---------------|
        |clickhouse_user| clickhouse user name to connect clickhouse service |
        |clickhouse_password| clickhouse password to connect clickhouse service |

- В папке /group_vars/clickhouse указываем версии пакетов и их название
        
        --------------
        |vars|description|
        |----------|---------------|
        |clickhouse_version| Version of clickhouse to install|
        |clickhouse_packages| Name packages to install |

- В папке /group_vars/vector задаютяс переменные репозитория, пакета, настройки для nginx и подключения к cklickhouse
        
        --------------
        |vars|description|
        |----------|---------------|
        |vector_version| Version of Vector to install|
        |nginx_user_name| User to start nginx service|
        |vector_url| url from install Vector|
        |vector_packages| Package name to install|
        |vector_config| Content array to vector config files|

- В папке /group_vars/lighthouse задается url откуда копируем lighthouse и куда, логины для nginx и lighthouse

        --------------
        |vars|description|
        |----------|---------------|
        |lighthouse_vcs| Url from install lighthouse|
        |lighthouse_location_dir| Dir to location lighthouse|
        |lighthouse_access_log_name| User name access log lighthouse|
        |nginx_user_name|  User to start nginx service|
