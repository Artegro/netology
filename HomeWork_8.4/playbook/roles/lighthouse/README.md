lighthouse-role
=========

Install lighthouse on host

Role Variables
--------------

|vars|description|
|----------|---------------|
|lighthouse_path| local path to lighthouse files|
|lighthouse_port| port lighthouse|
|clickhouse_host| addres to connect  clickhouse|
|clickhouse_port|port clickhouse|
|clickhouse_user| user name to connect clickhouse|
|clickhouse_password| password user to connect clickhouse|


Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: lighthouse}

License
-------
MIT

Author Information
------------------

Artem Grod
