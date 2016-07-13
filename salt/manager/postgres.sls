{% if grains['os_family'] == 'RedHat' %}
postgresql-server:
  pkg.installed

postgresql_initdb:
  cmd.run:
    - cwd: /
    - user: root
    - name: postgresql-setup initdb
    - unless: test -f /var/lib/pgsql/data/postgresql.conf
    - env:
      LC_ALL: C.UTF-8
  file.managed:
    - name: /var/lib/pgsql/data/pg_hba.conf
    - template: jinja
    - source: salt://manager/files/pg_hba.conf
    - user: postgres
    - group: postgres
    - mode: 600
    - require:
       - cmd: postgresql_initdb
{% endif %}

postgres_service:
  service.running:
    - name: postgresql
    - enable: True
    {% if grains['os_family'] == 'RedHat' %}
    - require:
      - file: postgresql_initdb
    {% endif %}

dbuser:
  postgres_user.present:
    - name: {{ pillar['database']['user'] }}
    - password: {{ pillar['database']['password'] }}
    - user: postgres
    - require:
      - service: postgresql

database:
  postgres_database.present:
    - name: {{ pillar['database']['name'] }}
    - encoding: UTF8
    - lc_ctype: en_US.UTF8
    - lc_collate: en_US.UTF8
    - template: template0
    - owner: {{ pillar['database']['user'] }}
    - user: postgres
    - require:
      - service: postgresql
      - postgres_user: dbuser
