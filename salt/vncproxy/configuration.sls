/home/{{ pillar['user'] }}/.virtualenvs/vncproxy/bin/postactivate:
  file.managed:
    - source: salt://vncproxy/files/postactivate
    - template: jinja
    - user: {{ pillar['user'] }}
    - mode: 700

/etc/init/vncproxy.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/vncproxy/miscellaneous/vncproxy.conf
