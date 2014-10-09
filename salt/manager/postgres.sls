postgres_service:
  service.running:
    - name: postgresql

dbuser:
  postgres_user.present:
    - name: {{ pillar['database']['user'] }}
    - password: {{ pillar['database']['password'] }}
    - runas: postgres
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
    - runas: postgres
    - require:
      - service: postgresql
      - postgres_user: dbuser
