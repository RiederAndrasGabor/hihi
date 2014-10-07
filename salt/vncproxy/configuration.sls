/home/{{ pillar['user'] }}/.virtualenvs/vncproxy/bin/postactivate:
  file.managed:
    - source: salt://vncproxy/files/postactivate
    - template: jinja
    - user: {{ pillar['user'] }}
    - mode: 700

/etc/init/vncproxy.conf:
  file.copy:
    - user: root
    - group: root
    - source: /home/{{ pillar['user'] }}/vncproxy/miscellaneous/vncproxy.conf
