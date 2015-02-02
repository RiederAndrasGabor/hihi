rabbitmq-server_monitor:
  pkg.installed:
    - name: rabbitmq-server
  service:
    - running
    - name: rabbitmq-server
    - require:
      - pkg: rabbitmq-server 

rabbitmq_user_monitor:
  rabbitmq_user.present:
    - name: {{ pillar['graphite']['user'] }}
    - password: {{ pillar['graphite']['password'] }}

virtual_host_monitor:
    rabbitmq_vhost.present:
        - name: {{ pillar['graphite']['vhost']}}
        - user: {{ pillar['graphite']['user'] }}
        - conf: .*
        - write: .*
        - read: .*
