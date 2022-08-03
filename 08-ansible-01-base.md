# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению

<details>
<summary>Раскрыть условие задачи</summary>

> 1. Установите ansible версии 2.10 или выше.
> 2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
> 3. Скачайте playbook из репозитория с домашним заданием и перенесите его в свой репозиторий.

</details>

```shell
❯ ansible --version
ansible [core 2.13.1]
  config file = None
  configured module search path = ['/Users/dmitriynenashev/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /opt/homebrew/Cellar/ansible/6.1.0/libexec/lib/python3.10/site-packages/ansible
  ansible collection location = /Users/dmitriynenashev/.ansible/collections:/usr/share/ansible/collections
  executable location = /opt/homebrew/bin/ansible
  python version = 3.10.5 (main, Jun 23 2022, 17:07:30) [Clang 13.0.0 (clang-1300.0.29.30)]
  jinja version = 3.1.2
  libyaml = True
```

## Основная часть

1. Попробуйте запустить playbook на окружении из test.yml, зафиксируйте какое значение имеет факт some_fact для указанного хоста при выполнении playbook'a.

```shell
❯ ansible-playbook site.yml -i inventory/test.yml

PLAY [Print os facts] *******************************************************************************************

TASK [Gathering Facts] ******************************************************************************************
[WARNING]: Platform darwin on host localhost is using the discovered Python interpreter at
/opt/homebrew/bin/python3.9, but future installation of another Python interpreter could change the meaning of
that path. See https://docs.ansible.com/ansible-core/2.13/reference_appendices/interpreter_discovery.html for
more information.
ok: [localhost]

TASK [Print OS] *************************************************************************************************
ok: [localhost] => {
    "msg": "MacOSX"
}

TASK [Print fact] ***********************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP ******************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'. 

```shell
❯ grep -r "some_fact" ./group_vars/
./group_vars//el/examp.yml:  some_fact: "el"
./group_vars//all/examp.yml:  some_fact: 12
./group_vars//deb/examp.yml:  some_fact: "deb"
❯ cat ./group_vars/all/examp.yml
---
  some_fact: "all default fact"
```

3. Воспользуйтесь подготовленным (используется docker) или создайте собственное окружение для проведения дальнейших испытаний.
```shell
❯ docker ps
CONTAINER ID   IMAGE           COMMAND       CREATED          STATUS          PORTS     NAMES
4d884bd3f328   centos:latest   "/bin/bash"   9 seconds ago    Up 7 seconds              centos
f3b9a6a65cc8   ubuntu:latest   "bash"        22 seconds ago   Up 20 seconds             ubuntu
```

4.Запуск playbook на окружении из prod.yml. Зафиксировать полученные значения some_fact для каждого из managed host.
```shell
❯ ansible-playbook site.yml -i inventory/prod.yml

PLAY [Print os facts] *******************************************************************************************

TASK [Gathering Facts] ******************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***********************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP ******************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```
5. Добавьте факты в group_vars каждой из групп хостов так, чтобы для some_fact получились следующие значения: для deb - 'deb default fact', для el - 'el default fact'.

```shell
❯ grep -r "some_fact" ./group_vars/
./group_vars//el/examp.yml:  some_fact: "el default fact"
./group_vars//all/examp.yml:  some_fact: "all default fact"
./group_vars//deb/examp.yml:  some_fact: "deb default fact"
```
6. Повторите запуск playbook на окружении prod.yml. Убедитесь, что выдаются корректные значения для всех хостов.

```shell
❯ ansible-playbook site.yml -i inventory/prod.yml

PLAY [Print os facts] *******************************************************************************************

TASK [Gathering Facts] ******************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***********************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ******************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

7. При помощи ansible-vault зашифруйте факты в group_vars/deb и group_vars/el с паролем netology.
```shell
❯ ansible-vault encrypt group_vars/deb/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful
❯ ansible-vault encrypt group_vars/el/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful
```

8. Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь в работоспособности.

```shell
❯ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] *******************************************************************************************

TASK [Gathering Facts] ******************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***********************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ******************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
9. Посмотрите при помощи ansible-doc список плагинов для подключения. Выберите подходящий для работы на control node.
```shell
❯ ansible-doc -t connection -l | grep controller
community.docker.nsenter       execute on host running controller container
local                          execute on controller
```

10. В prod.yml добавьте новую группу хостов с именем local, в ней разместите localhost с необходимым типом подключения.
```shell
❯ cat inventory/prod.yml
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_host: localhost
        ansible_connection: local
```

11. Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь что факты some_fact для каждого из хостов определены из верных group_vars.

```shell
❯ sudo ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Password:
Vault password:

PLAY [Print os facts] *******************************************************************************************

TASK [Gathering Facts] ******************************************************************************************
ok: [ubuntu]
ok: [centos7]
[WARNING]: Platform darwin on host localhost is using the discovered Python interpreter at
/opt/homebrew/bin/python3.9, but future installation of another Python interpreter could change the meaning of
that path. See https://docs.ansible.com/ansible-core/2.13/reference_appendices/interpreter_discovery.html for
more information.
ok: [localhost]

TASK [Print OS] *************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "MacOSX"
}

TASK [Print fact] ***********************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP ******************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

12. Заполните README.md ответами на вопросы. Сделайте git push в ветку master. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым playbook и заполненным README.md.

## Необязательная часть

1. При помощи ansible-vault расшифруйте все зашифрованные файлы с переменными.

```shell
❯ ansible-vault decrypt group_vars/deb/examp.yml --vault-password-file pass.txt
Decryption successful
❯ ansible-vault decrypt group_vars/el/examp.yml --vault-password-file pass.txt
Decryption successful
```

2. Зашифруйте отдельное значение PaSSw0rd для переменной some_fact паролем netology. Добавьте полученное значение в group_vars/all/exmp.yml.

```shell
❯ ansible-vault encrypt_string --vault-password-file pass.txt PaSSw0rd
Encryption successful
!vault |
          $ANSIBLE_VAULT;1.1;AES256
          38333364633565376166323466626164633431386333666365343537383266386338343136643734
          6166643033356631623062653663643634336332373164660a333838343037333963303933636165
          64373664326637323937326165383862626461356136356436656130383231656264366435323862
          3835646164383364630a663133383933383763353039653132323138386436323565666533356232
          6330
```
```shell
❯ cat ./group_vars/all/examp.yml
---
  some_fact: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          38333364633565376166323466626164633431386333666365343537383266386338343136643734
          6166643033356631623062653663643634336332373164660a333838343037333963303933636165
          64373664326637323937326165383862626461356136356436656130383231656264366435323862
          3835646164383364630a663133383933383763353039653132323138386436323565666533356232
          6330
```

3. Запустите playbook, убедитесь, что для нужных хостов применился новый fact.
```shell
❯ ansible-playbook site.yml -i inventory/prod.yml --vault-pass-file pass.txt

PLAY [Print os facts] *******************************************************************************************

TASK [Gathering Facts] ******************************************************************************************
ok: [ubuntu]
ok: [centos7]
[WARNING]: Platform darwin on host localhost is using the discovered Python interpreter at
/opt/homebrew/bin/python3.9, but future installation of another Python interpreter could change the meaning of
that path. See https://docs.ansible.com/ansible-core/2.13/reference_appendices/interpreter_discovery.html for
more information.
ok: [localhost]

TASK [Print OS] *************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "MacOSX"
}

TASK [Print fact] ***********************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}

PLAY RECAP ******************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

4. Добавьте новую группу хостов fedora, самостоятельно придумайте для неё переменную.

```shell
❯ ansible-playbook site.yml -i inventory/prod.yml --vault-password-file pass.txt

PLAY [Print os facts] *******************************************************************************************

TASK [Gathering Facts] ******************************************************************************************
ok: [ubuntu]
ok: [fedora]
ok: [centos7]
[WARNING]: Platform darwin on host localhost is using the discovered Python interpreter at
/opt/homebrew/bin/python3.9, but future installation of another Python interpreter could change the meaning of
that path. See https://docs.ansible.com/ansible-core/2.13/reference_appendices/interpreter_discovery.html for
more information.
ok: [localhost]

TASK [Print OS] *************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [fedora] => {
    "msg": "Fedora"
}
ok: [localhost] => {
    "msg": "MacOSX"
}

TASK [Print fact] ***********************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [fedora] => {
    "msg": "PaSSw0rd"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}

TASK [Print custom var] *****************************************************************************************
skipping: [centos7]
skipping: [ubuntu]
ok: [fedora] => {
    "msg": "Hi, i am Fedora!"
}
skipping: [localhost]

PLAY RECAP ******************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
fedora                     : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
```

5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
```bash
#!/usr/local/env bash
docker-compose up -d
ansible-playbook site.yml -i inventory/prod.yml --vault-password-file vault_password.txt
docker-compose down
```

6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.

`Сделано`