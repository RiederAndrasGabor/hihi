/home/{{ pillar['user'] }}/.virtualenvs/monitor-client/bin/postactivate:
  file.managed:
    - source: salt://monitor-client/files/postactivate
    - template: jinja
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - mode: 700

/etc/init/monitor-client.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/monitor-client/miscellaneous/monitor-client.conf
