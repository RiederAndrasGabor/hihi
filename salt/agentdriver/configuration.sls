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
    - user: {{ pillar['user'] }}

/etc/init/agentdriver.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/agentdriver/miscellaneous/agentdriver.conf

/var/lib/libvirt/serial:
  file.directory:
    - makedirs: True
