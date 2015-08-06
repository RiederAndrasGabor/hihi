rabbitmq-server:
  pkg.installed:
    - name: rabbitmq-server
  {% if grains['os_family'] == 'RedHat' %}
  file.managed:
    - name: /etc/rabbitmq/rabbitmq-env.conf
    - contents: RABBITMQ_DIST_PORT=5671
  {% endif %}
  service.running:
    - enable: True
    - require:
      - pkg: rabbitmq-server
      {% if grains['os_family'] == 'RedHat' %}
      - file: rabbitmq-server
      {% endif %}

rabbitmq_user:
  rabbitmq_user.present:
    - name: {{ pillar['amqp']['user'] }}
    - password: {{ pillar['amqp']['password'] }}
    - require:
      - service: rabbitmq-server

virtual_host:
  rabbitmq_vhost.present:
    - name: {{ pillar['amqp']['vhost']}}
    - user: {{ pillar['amqp']['user'] }}
    - conf: .*
    - write: .*
    - read: .*
    - require:
      - service: rabbitmq-server

{% if pillar["deployment_mode"] == "multinode" %}
open_amqp_port:
  cmd.run:
    {% if grains['os_family'] == 'RedHat' %}
    - name: >
        firewall-cmd --complete-reload ;
        firewall-cmd --permanent --zone=public --add-port=5672/tcp ;
        firewall-cmd --reload
    {% else %}
    - name: ufw allow 5672/tcp
    {% endif %}

{% endif %}
