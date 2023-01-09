# Домашнее задание к занятию "8.6.Создание собственных модулей"

## Подготовка к выполнению
1. Создайте пустой публичных репозиторий в любом своём проекте: `my_own_collection`
2. Скачайте репозиторий ansible: `git clone https://github.com/ansible/ansible.git` по любому удобному вам пути
3. Зайдите в директорию ansible: `cd ansible`
4. Создайте виртуальное окружение: `python3 -m venv venv`
5. Активируйте виртуальное окружение: `. venv/bin/activate`. Дальнейшие действия производятся только в виртуальном окружении
6. Установите зависимости `pip install -r requirements.txt`
7. Запустить настройку окружения `. hacking/env-setup`
8. Если все шаги прошли успешно - выйти из виртуального окружения `deactivate`
9. Ваше окружение настроено, для того чтобы запустить его, нужно находиться в директории `ansible` и выполнить конструкцию `. venv/bin/activate && . hacking/env-setup`

### Выполнение подготовки
```bash
 19:36:12 @ ~/my-ansible/8.6/my_own_collection []
└─ #  git clone https://github.com/ansible/ansible.git
Cloning into 'ansible'...
remote: Enumerating objects: 591960, done.
remote: Counting objects: 100% (253/253), done.
remote: Compressing objects: 100% (203/203), done.
remote: Total 591960 (delta 61), reused 208 (delta 30), pack-reused 591707
Receiving objects: 100% (591960/591960), 227.33 MiB | 4.99 MiB/s, done.
Resolving deltas: 100% (394182/394182), done.

 19:38:37 @ ~/my-ansible/8.6/my_own_collection []
└─ #  cd ansible/

 19:38:43 @ ~/my-ansible/8.6/my_own_collection/ansible [devel]
└─ #  python3 -m venv venv

 19:39:54 @ ~/my-ansible/8.6/my_own_collection/ansible [devel]
└─ #  . venv/bin/activate

(venv)  19:41:12 @ ~/my-ansible/8.6/my_own_collection/ansible [devel]
└─ #  pip install -r requirements.txt
Collecting jinja2>=3.0.0
  Using cached Jinja2-3.1.2-py3-none-any.whl (133 kB)
Collecting PyYAML>=5.1
  Using cached PyYAML-6.0-cp39-cp39-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_12_x86_64.manylinux2010_x86_64.whl (661 kB)
Collecting cryptography
  Downloading cryptography-39.0.1-cp36-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (4.2 MB)
     |████████████████████████████████| 4.2 MB 135 kB/s
-----------------ВЫВОД ПРОПУЩЕН-------------------------------------------
Installing collected packages: MarkupSafe, jinja2, PyYAML, pycparser, cffi, cryptography, packaging, importlib-resources, resolvelib
Successfully installed MarkupSafe-2.1.2 PyYAML-6.0 cffi-1.15.1 cryptography-39.0.1 importlib-resources-5.0.7 jinja2-3.1.2 packaging-23.0 pycparser-2.21 resolvelib-0.9.0

(venv)  19:56:37 @ ~/my-ansible/8.6/my_own_collection/ansible [devel]
└─ #  . hacking/env-setup
running egg_info
creating lib/ansible_core.egg-info

-----------------ВЫВОД ПРОПУЩЕН-------------------------------------------

Setting up Ansible to run out of checkout...

PATH=/root/my-ansible/8.6/my_own_collection/ansible/bin:/root/my-ansible/8.6/my_own_collection/ansible/venv/bin:/root/yandex-cloud/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/.local/bin:/usr/local/go/bin:/root/bin
PYTHONPATH=/root/my-ansible/8.6/my_own_collection/ansible/test/lib:/root/my-ansible/8.6/my_own_collection/ansible/lib
MANPATH=/root/my-ansible/8.6/my_own_collection/ansible/docs/man:/usr/local/share/man:/usr/share/man

Remember, you may wish to specify your host file with -i

Done!

(venv)  19:58:48 @ ~/my-ansible/8.6/my_own_collection/ansible [devel]
└─ #  deactivate
 19:59:10 @ ~/my-ansible/8.6/my_own_collection/ansible [devel]
└─ #
```

## Основная часть

Наша цель - написать собственный module, который мы можем использовать в своей role, через playbook. Всё это должно быть собрано в виде collection и отправлено в наш репозиторий.

1. В виртуальном окружении создать новый `my_own_module.py` файл
2. Наполнить его содержимым из [статьи](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general.html#creating-a-module).
3. Заполните файл в соответствии с требованиями ansible так, чтобы он выполнял основную задачу: module должен создавать текстовый файл на удалённом хосте по пути, определённом в параметре `path`, с содержимым, определённым в параметре `content`.
4. Проверьте module на исполняемость локально.
5. Напишите single task playbook и используйте module в нём.
6. Проверьте через playbook на идемпотентность.
7. Выйдите из виртуального окружения.
8. Инициализируйте новую collection: `ansible-galaxy collection init my_own_namespace.yandex_cloud_elk`
9. В данную collection перенесите свой module в соответствующую директорию.
10. Single task playbook преобразуйте в single task role и перенесите в collection. У role должны быть default всех параметров module
11. Создайте playbook для использования этой role.
12. Заполните всю документацию по collection, выложите в свой репозиторий, поставьте тег `1.0.0` на этот коммит.
13. Создайте .tar.gz этой collection: `ansible-galaxy collection build` в корневой директории collection.
14. Создайте ещё одну директорию любого наименования, перенесите туда single task playbook и архив c collection.
15. Установите collection из локального архива: `ansible-galaxy collection install <archivename>.tar.gz`
16. Запустите playbook, убедитесь, что он работает.
17. В ответ необходимо прислать ссылки на collection и tar.gz архив, а также скриншоты выполнения пунктов 4, 6, 15 и 16.

### Выполнение основной части

1. В виртуальном окружении создать новый `my_own_module.py` файл
2. Наполнить его содержимым из [статьи](https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general.html#creating-a-module).
3. Заполните файл в соответствии с требованиями ansible так, чтобы он выполнял основную задачу: module должен создавать текстовый файл на удалённом хосте по пути, определённом в параметре `path`, с содержимым, определённым в параметре `content`.
```
Содержимое файла my_own_module.py:
```
```python
#!/usr/bin/python

# Copyright: (c) 2018, Terry Jones <terry.jones@example.org>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: my_own_module

short_description: This is my test module

# If this is part of a collection, you need to use semantic versioning,
# i.e. the version is of the form "2.5.0" and not "2.4".
version_added: "1.0.0"

description: This is my longer description explaining my test module.

options:
    name:
        description: This is the message to send to the test module.
        required: true
        type: str
    new:
        description:
            - Control to demo if the result of this module is changed or not.
            - Parameter description can be a list as well.
        required: false
        type: bool
# Specify this value according to your collection
# in format of namespace.collection.doc_fragment_name
extends_documentation_fragment:
    - my_namespace.my_collection.my_doc_fragment_name

author:
    - Evgeni Listopad
'''

EXAMPLES = r'''
# Pass in a message
- name: Test with a message
  my_namespace.my_collection.my_test:
    name: hello world

# pass in a message and have changed true
- name: Test with a message and changed output
  my_namespace.my_collection.my_test:
    name: hello world
    new: true

# fail the module
- name: Test failure of the module
  my_namespace.my_collection.my_test:
    name: fail me
'''

RETURN = r'''
# These are examples of possible return values, and in general should use other names for return values.
original_message:
    description: The original name param that was passed in.
    type: str
    returned: always
    sample: 'hello world'
message:
    description: The output message that the test module generates.
    type: str
    returned: always
    sample: 'goodbye'
'''

from ansible.module_utils.basic import AnsibleModule
import os.path

def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        path=dict(type='str', required=True),
        content=dict(type='str', required=True)
    )

    # seed the result dict in the object
    # we primarily care about changed and state
    # changed is if this module effectively modified the target
    # state will include any data that you want your module to pass back
    # for consumption, for example, in a subsequent task
    result = dict(
        changed=False,
        message=''
    )

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    # if the user is working with this module in only check mode we do not
    # want to make any changes to the environment, just return the current
    # state with no modifications
    if module.check_mode:
        module.exit_json(**result)

    if os.path.exists(module.params['path']):
        result['changed'] = False
        result['message'] = 'File already exists'
    else:
        target_file = open(module.params['path'],"w")
        target_file.write(module.params['content'])
        target_file.close()
        result['changed'] = True
        result['message'] = 'File was created!'

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()
```
4. Проверьте module на исполняемость локально.
```
Для этого создадим файл payload.json:
{
        "ANSIBLE_MODULE_ARGS": {
                "path": "test_file",
                "content": "Some content"
        }
}
```
```
Проверяем module на исполняемость локально:
(venv)  00:29:24 @ ~/my-ansible/8.6/my_own_collection/ansible [devel]
└─ #  python -m ansible.modules.my_own_module payload.json

{"changed": false, "message": "File already exists", "invocation": {"module_args": {"path": "test_file", "content": "Some content"}}}
(venv)  00:29:41 @ ~/my-ansible/8.6/my_own_collection/ansible [devel]
└─ #  cat test_file
Some content
```
5. Напишите single task playbook и используйте module в нём.
```
(venv)  00:39:11 @ ~/my-ansible/8.6/my_own_collection/ansible [devel]
└─ #  cat site.yml
---
- name: Test module
  hosts: localhost
  tasks:
          - name: Call my_own_module
            my_own_module:
                    path: test_file
                    content: Some content
```
6. Проверьте через playbook на идемпотентность.
```
(venv)  00:39:48 @ ~/my-ansible/8.6/my_own_collection/ansible [devel]
└─ #  ansible-playbook site.yml
[WARNING]: You are running the development version of Ansible. You should only run Ansible from
"devel" if you are modifying the Ansible engine, or trying out features under development. This
is a rapidly changing source of code and can become unstable at any point.
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit
localhost does not match 'all'

PLAY [Test module] *****************************************************************************

TASK [Gathering Facts] *************************************************************************
ok: [localhost]

TASK [Call my_own_module] **********************************************************************
changed: [localhost]

PLAY RECAP *************************************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

(venv)  00:40:03 @ ~/my-ansible/8.6/my_own_collection/ansible [devel]
└─ #
(venv)  00:40:20 @ ~/my-ansible/8.6/my_own_collection/ansible [devel]
└─ #  ansible-playbook site.yml
[WARNING]: You are running the development version of Ansible. You should only run Ansible from
"devel" if you are modifying the Ansible engine, or trying out features under development. This
is a rapidly changing source of code and can become unstable at any point.
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit
localhost does not match 'all'

PLAY [Test module] *****************************************************************************

TASK [Gathering Facts] *************************************************************************
ok: [localhost]

TASK [Call my_own_module] **********************************************************************
ok: [localhost]

PLAY RECAP *************************************************************************************
localhost                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

(venv)  00:40:24 @ ~/my-ansible/8.6/my_own_collection/ansible [devel]
└─ #
```
7. Выйдите из виртуального окружения.
```
(venv)  00:51:33 @ ~/my-ansible/8.6/my_own_collection/ansible [devel]
└─ #  deactivate
 00:51:39 @ ~/my-ansible/8.6/my_own_collection/ansible [devel]
└─ #
```
8. Инициализируйте новую collection: `ansible-galaxy collection init my_own_namespace.yandex_cloud_elk`
```
 01:03:44 @ ~/my-ansible/8.6/my_own_collection []
└─ #  ansible-galaxy collection init my_own_namespace.yandex_cloud_elk
- Collection my_own_namespace.yandex_cloud_elk was created successfully
```
9. В данную collection перенесите свой module в соответствующую директорию.
```
 01:07:59 @ ~/my-ansible/8.6/my_own_collection []
└─ #  mkdir my_own_namespace/yandex_cloud_elk/plugins/modules
 01:11:12 @ ~/my-ansible/8.6/my_own_collection []
└─ #  cp my_own_module.py my_own_namespace/yandex_cloud_elk/plugins/modules/
```
10. Single task playbook преобразуйте в single task role и перенесите в collection. У role должны быть default всех параметров module
```
 01:12:06 @ ~/my-ansible/8.6/my_own_collection []
└─ #  ansible-galaxy role init my_own_role
- Role my_own_role was created successfully
 01:13:45 @ ~/my-ansible/8.6/my_own_collection []
└─ #  cd my_own_role/
 01:17:52 @ ~/my-ansible/8.6/my_own_collection/my_own_role []
└─ #  cat defaults/main.yml
---
# defaults file for my_own_role
path: 'test_file'
content: 'Some content'
 01:31:10 @ ~/my-ansible/8.6/my_own_collection/my_own_role []
└─ #  cat tasks/main.yml
---
# tasks file for my_own_role
- name: Create file
  my_own_module:
    path: "{{ path }}"
    content: "{{ content }}"
```
11. Создайте playbook для использования этой role.
```
 01:35:23 @ ~/my-ansible/8.6/my_own_collection []
└─ #  cat my_own_playbook.yml
---
- name: Using my_own_role
  hosts: localhost
  roles:
    - role: my_own_role
```
12. Заполните всю документацию по collection, выложите в свой репозиторий, поставьте тег `1.0.0` на этот коммит.
[collection](./TASK_8.6/collection)
13. Создайте .tar.gz этой collection: `ansible-galaxy collection build` в корневой директории collection.
```
 01:51:46 @ ~/my-ansible/8.6/my_own_collection/my_own_namespace/yandex_cloud_elk []
└─ #  ansible-galaxy collection build
Created collection for my_own_namespace.yandex_cloud_elk at /root/my-ansible/8.6/my_own_collection/my_own_namespace/yandex_cloud_elk/my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz
```
14. Создайте ещё одну директорию любого наименования, перенесите туда single task playbook и архив c collection.
```
 01:52:47 @ ~/my-ansible/8.6 []
└─ #  mkdir test_collection
 01:53:03 @ ~/my-ansible/8.6 []
└─ #  cd test_collection/
 01:53:07 @ ~/my-ansible/8.6/test_collection []
└─ #  cp  ../my_own_collection/my_own_namespace/yandex_cloud_elk/my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz ../my_own_collection/my_own_playbook.yml .
 01:54:07 @ ~/my-ansible/8.6/test_collection []
└─ #  ls
my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz  my_own_playbook.yml
```
15. Установите collection из локального архива: `ansible-galaxy collection install <archivename>.tar.gz`
```
 01:54:11 @ ~/my-ansible/8.6/test_collection []
└─ #  ansible-galaxy collection install my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz
Starting galaxy collection install process
Process install dependency map
Starting collection install process
Installing 'my_own_namespace.yandex_cloud_elk:1.0.0' to '/root/.ansible/collections/ansible_collections/my_own_namespace/yandex_cloud_elk'
my_own_namespace.yandex_cloud_elk:1.0.0 was installed successfully
 01:55:11 @ ~/my-ansible/8.6/test_collection []
└─ #  ls
my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz  my_own_playbook.yml
```
16. Запустите playbook, убедитесь, что он работает.
```
 02:27:02 @ ~/my-ansible/8.6/test_collection []
└─ #  ansible-playbook my_own_playbook.yml
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that
the implicit localhost does not match 'all'

PLAY [Using my_own_role] *******************************************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [my_own_namespace.yandex_cloud_elk.my_own_role : Create file] *************
changed: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

 02:27:12 @ ~/my-ansible/8.6/test_collection []
└─ #  ls
my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz  my_own_playbook.yml  test_file
```
17. Cсылки на [collection](./TASK_8.6/collection) и [tar.gz архив](./TASK_8.6/tar.gz), а также скриншоты выполнения пунктов: 
- Проверяем module на исполняемость локально
[4](./TASK_8.6/4.png)
- Проверяем module через playbook на идемпотентность
[6](./TASK_8.6/6.png)
- Устанавливаем collection из локального архива
[15](./TASK_8.6/15.png)
- Запускаем playbook, удаляем созданный файл. Запускаем повторно. Всё работает.
[16](./TASK_8.6/16.png)


