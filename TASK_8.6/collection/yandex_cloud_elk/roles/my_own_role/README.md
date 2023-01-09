Role Name
=========

This role uses a module for creation a text file.

Requirements
------------

The role doesn't have any requirements

Role Variables
--------------

path=dict(type='str', required=True),
content=dict(type='str', required=True)

Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

BSD

Author Information
------------------

Evgeni Listopad
