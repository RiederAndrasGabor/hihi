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
    - require:
      - rabbitmq_vhost: virtual_host_monitor
    - perms:
      - {{ pillar['graphite']['vhost']}}:
        - .*
        - .*
        - .*

virtual_host_monitor:
    rabbitmq_vhost.present:
        - name: {{ pillar['graphite']['vhost']}}
