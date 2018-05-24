/home/{{ pillar['user'] }}/.virtualenvs/monitor-client/bin/postactivate:
  file.managed:
    - source: salt://monitor-client/files/postactivate
    - template: jinja
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - mode: 700

{% if grains['os_family'] == 'RedHat' or grains['os'] == 'Debian' or grains['os'] == 'Ubuntu' and grains['oscodename'] == 'xenial' %}
/etc/systemd/system/monitor-client.service:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/monitor-client/miscellaneous/monitor-client.service

{% else %}

/etc/init/monitor-client.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/monitor-client/miscellaneous/monitor-client.conf
{% endif %}
