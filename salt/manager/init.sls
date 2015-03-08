include:
  - manager.pipeline
  - manager.gitrepo
  - manager.agentgit
  - manager.postgres
  - manager.rabbitmq
  - manager.virtualenv
  - manager.configuration
  - manager.nginx

manager:
  pkg.installed:
    - pkgs:
      - postgresql
      - git
      - python-pip
      - ntp
      - rabbitmq-server
      - memcached
      - gettext
      - wget
      - swig
      {% if grains['os_family'] == 'RedHat' %}
      - libmemcached-devel
      - postgresql-devel
      - postgresql-libs
      - postgresql-server
      - libxml2-devel
      - libxslt-devel
      - python-devel
      - python-virtualenvwrapper
      {% else %}
      - libmemcached-dev
      - libpq-dev
      - libxml2-dev
      - libxslt1-dev
      - python-dev
      - virtualenvwrapper
      {% endif %}
    - require_in:
      - service: postgres_service
  user:
    - present
    - name: {{ pillar['user'] }}
    - gid_from_name: True
    - shell: /bin/bash
    - groups:
      {% if grains['os_family'] == 'RedHat' %}
      - wheel
      {% else %}
      - sudo
      {% endif %}
     

  service:
    - running
    - enable: True
    - watch:
      - file: manager_postactivate
      {% if grains['os_family'] == 'RedHat' %}
      - file: /etc/systemd/system/manager.service
      - file: /etc/systemd/system/managercelery@.service
      {% else %}
      - file: /etc/init/manager.conf
      - file: /etc/init/mancelery.conf
      - file: /etc/init/moncelery.conf
      - file: /etc/init/slowcelery.conf
      {% endif %}
      - sls: manager.gitrepo

portal:
  service:
    - running
    - enable: True
    - watch:
      - file: manager_postactivate
      - file: portal.conf

memcached:
  service:
    - running
    - enable: True
    - require:
      - pkg: manager
