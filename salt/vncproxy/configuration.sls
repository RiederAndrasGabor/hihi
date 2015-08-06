/home/{{ pillar['user'] }}/.virtualenvs/vncproxy/bin/postactivate:
  file.managed:
    - source: salt://vncproxy/files/postactivate
    - template: jinja
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - mode: 700

{% if grains['os_family'] == 'RedHat' or grains['os'] == 'Debian' %}
/etc/systemd/system/vncproxy.service:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/vncproxy/miscellaneous/vncproxy.service

{% else %}

/etc/init/vncproxy.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/vncproxy/miscellaneous/vncproxy.conf
{% endif %}
