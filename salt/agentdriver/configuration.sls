/home/{{ pillar['user'] }}/.virtualenvs/agentdriver/bin/postactivate:
  file.managed:
    - source: salt://agentdriver/files/postactivate
    - template: jinja
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - mode: 700

/etc/incron.d/agentdriver:
  file.managed:
    - source: salt://agentdriver/files/agentdriver.incron
    - template: jinja
    - user: root
    - group: root

{% if grains['os_family'] == 'RedHat' or grains['os'] == 'Debian' or grains['os'] == 'Ubuntu' and grains['oscodename'] == 'xenial' %}
/etc/systemd/system/agentdriver.service:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/agentdriver/miscellaneous/agentdriver.service

{% else %}

/etc/init/agentdriver.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/agentdriver/miscellaneous/agentdriver.conf
{% endif %}

{% if grains['os_family'] == 'RedHat' %}
incrond:
{% else %}
incron:
{% endif %}
  service:
    - full_restart: true
    - enable: true
    - running
    - watch:
      - file: /etc/incron.d/agentdriver
