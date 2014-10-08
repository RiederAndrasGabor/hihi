rabbitmq-server:
  pkg.installed:
    - name: rabbitmq-server
  service:
    - running

rabbitmq_user:
  rabbitmq_user.present:
    - name: {{ pillar['graphite']['user'] }}
    - password: {{ pillar['graphite']['password'] }}

virtual_host:
    rabbitmq_vhost.present:
        - name: {{ pillar['graphite']['vhost']}}
        - user: {{ pillar['graphite']['user'] }}
        - conf: .*
        - write: .*
        - read: .*
