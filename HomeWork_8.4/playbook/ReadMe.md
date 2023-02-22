# Playbook из файла site.yml
- Данный playbook устанавливает ClickHouse, Vector и lighthouse на хосты с помощю ролей которые скачиваем из репозиториев указаных в файле requirements.yml
- Inventory при этом использовал /inventory/prod.yml

# Параметры и переменные
- Тип коннекторов подключения к хостам, в нашем случае это ip и username а так же их имена задаются в файлах дерриктории /inventory
- Переменные определяются в ролях но так же мы можем переопределять следующие переменные: 
        
        Для vector: 
            |vector_version| Version of Vector to install|
            |nginx_user_name| User to start nginx service|

        Для lighthouse:
            |lighthouse_path| local path to lighthouse files|
            |lighthouse_port| port lighthouse|
            |clickhouse_host| addres to connect  clickhouse|
            |clickhouse_port|port clickhouse|
            |clickhouse_user| user name to connect clickhouse|
            |clickhouse_password| password user to connect clickhouse|

