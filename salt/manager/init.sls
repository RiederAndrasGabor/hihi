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
      - virtualenvwrapper
      - postgresql
      - git
      - python-pip
      - python-dev
      - libpq-dev
      - ntp
      - rabbitmq-server
      - memcached
      - gettext
      - wget
      - libxml2-dev
      - libxslt1-dev
      - libmemcached-dev
    - require_in:
      - service: postgres_service
  user:
    - present
    - name: {{ pillar['user'] }}
    - gid_from_name: True
     

  service:
    - running
    - watch:
      - file: manager_postactivate
      - file: /etc/init/manager.conf
      - file: /etc/init/mancelery.conf
      - file: /etc/init/moncelery.conf
      - file: /etc/init/slowcelery.conf
      - sls: manager.gitrepo

portal:
  service:
    - running
