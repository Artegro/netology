# Домашнее задание к занятию "4. Работа с roles"

## Подготовка к выполнению
1. (Необязательно) Познакомтесь с [lighthouse](https://youtu.be/ymlrNlaHzIY?t=929)

        Готово

2. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.

    Готово
    [netology-lighthouse-role](https://github.com/Artegro/netology-lighthouse-role)
    [netology-vector-role](https://github.com/Artegro/netology-vector-role)
3. Добавьте публичную часть своего ключа к своему профилю в github.

## Основная часть

Наша основная цель - разбить наш playbook на отдельные roles. Задача: сделать roles для clickhouse, vector и lighthouse и написать playbook для использования этих ролей. Ожидаемый результат: существуют три ваших репозитория: два с roles и один с playbook.

1. Создать в старой версии playbook файл `requirements.yml` и заполнить его следующим содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.11.0"
       name: clickhouse 
   ```

2. При помощи `ansible-galaxy` скачать себе эту роль.
    
    Устанавливаем роль
    ```
    ansible-galaxy install -r requirements.yml -p clickhouse
    Starting galaxy role install process
    - extracting clickhouse to /home/artegro/netology/HomeWork_8.4/playbook/clickhouse/clickhouse
    - clickhouse (1.11.0) was installed successfully
    ```

3. Создать новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
    
    Иницилизируем роль
    ```
    ansible-galaxy role init vector-role
    - Role vector-role was created successfully
    ```
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 

    Для изменения оставил версию пакета 'vector_version: 0.21.1' и имя пользователя 'nginx_user_name: root' для запуска nginx
      [Выполнено](https://github.com/Artegro/netology-vector-role/blob/master/defaults/main.yml)

    Остальные переменнае изменять не будем. 
      [Выполнено](https://github.com/Artegro/netology-vector-role/blob/master/vars/main.yml)

5. Перенести нужные шаблоны конфигов в `templates`.

    [Выполнено](https://github.com/Artegro/netology-vector-role/tree/master/templates)

6. Описать в `README.md` обе роли и их параметры.

    [Vector readme](https://github.com/Artegro/netology-vector-role/tree/1.0.3#readme)
    [lighthouse readme](https://github.com/Artegro/netology-lighthouse-role/tree/1.0.2#readme)

7. Повторите шаги 3-6 для lighthouse. Помните, что одна роль должна настраивать один продукт.

    [Выполнено](hhttps://github.com/Artegro/netology-lighthouse-role/tree/1.0.2)

8. Выложите все roles в репозитории. Проставьте тэги, используя семантическую нумерацию Добавьте roles в `requirements.yml` в playbook.

    Запишем и проверим
  ```
    cat requirements.yml
      ---
        - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
          scm: git
          version: "1.11.0"
          name: clickhouse

        - name: vector
          src: git@github.com:Artegro/netology-vector-role.git
          scm: git
          version: "1.0.3"

        - name: lighthouse
          src: git@github.com:Artegro/netology-lighthouse-role.git
          scm: git
          version: "1.0.2"
    
    ansible-galaxy install -r requirements.yml -p roles
       Starting galaxy role install process
      - clickhouse (1.11.0) is already installed, skipping.
      - extracting vector to /home/artegro/netology/HomeWork_8.4/playbook/roles/vector
      - vector (1.0.3) was installed successfully
      - extracting lighthouse to /home/artegro/netology/HomeWork_8.4/playbook/roles/lighthouse
      - lighthouse (1.0.2) was installed successfully
  ```

9. Переработайте playbook на использование roles. Не забудьте про зависимости lighthouse и возможности совмещения `roles` с `tasks`.

    Выполнено
    ```
    cat site.yml
        ---
        - name: Install Clickhouse
          hosts: clickhouse
          roles:
            - clickhouse
        
        - name: Install Vector
          hosts: vector
          roles:
            - vector

        - name: Install Nginx
          hosts: lighthouse
          roles:
            - lighthouse
    ```

10. Выложите playbook в репозиторий.

      [Выполнено](https://github.com/Artegro/netology/tree/master/HomeWork_8.4/playbook)
      
11. В ответ приведите ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

---
