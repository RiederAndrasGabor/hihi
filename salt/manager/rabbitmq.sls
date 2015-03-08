rabbitmq-server:
  pkg.installed:
    - name: rabbitmq-server
  service.running:
    - enable: True
    - require:
      - pkg: rabbitmq-server

rabbitmq_user:
  rabbitmq_user.present:
    - name: {{ pillar['amqp']['user'] }}
    - password: {{ pillar['amqp']['password'] }}

virtual_host:
    rabbitmq_vhost.present:
        - name: {{ pillar['amqp']['vhost']}}
        - user: {{ pillar['amqp']['user'] }}
        - conf: .*
        - write: .*
        - read: .*
