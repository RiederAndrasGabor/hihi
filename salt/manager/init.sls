{% set amqp_islocal = (pillar['amqp']['host'] in ('localhost', '127.0.0.1')) %}

include:
  - manager.pipeline
  - manager.gitrepo
  - manager.agentgit
  - manager.postgres
  {% if amqp_islocal %}
  - manager.rabbitmq
  {% endif %}
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
      {% if amqp_islocal %}
      - rabbitmq-server
      {% endif %}
      - memcached
      - gettext
      - wget
      - swig
      {% if grains['os_family'] == 'RedHat' %}
      - libffi-devel
      - openssl-devel
      - libmemcached-devel
      - postgresql-devel
      - postgresql-libs
      - postgresql-server
      - libxml2-devel
      - libxslt-devel
      - python-devel
      - python-virtualenvwrapper
      {% else %}
      - libffi-dev
      - libssl-dev
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
      {% if grains['os_family'] == 'RedHat' or grains['os'] == 'Debian' or grains['osfinger'] == 'Ubuntu-16.04' %}
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
      - sls: manager.gitrepo

memcached:
  service:
    - running
    - enable: True
    - require:
      - pkg: manager
