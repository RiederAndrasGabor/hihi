/home/{{ pillar['user'] }}/.virtualenvs/agentdriver/bin/postactivate:
  file.managed:
    - source: salt://agentdriver/files/postactivate
    - template: jinja
    - user: {{ pillar['user'] }}
    - mode: 700

/etc/incron.d/agentdriver:
  file.managed:
    - source: salt://agentdriver/files/agentdriver.incron
    - template: jinja
    - user: {{ pillar['user'] }}

/etc/init/agentdriver.conf:
  file.copy:
    - user: root
    - group: root
    - source: /home/{{ pillar['user'] }}/agentdriver/miscellaneous/agentdriver.conf

/var/lib/libvirt/serial:
  file.directory:
    - makedirs: True
