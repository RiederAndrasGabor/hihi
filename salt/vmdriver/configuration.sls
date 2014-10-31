/home/{{ pillar['user'] }}/.virtualenvs/vmdriver/bin/postactivate:
  file.managed:
    - source: salt://vmdriver/files/postactivate
    - template: jinja
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - mode: 700

/etc/init/vmcelery.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/vmdriver/miscellaneous/vmcelery.conf

/etc/init/netcelery.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/vmdriver/miscellaneous/netcelery.conf

/etc/init/node.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/vmdriver/miscellaneous/node.conf

ovs-bridge:
  cmd.run:
    - name: ovs-vsctl add-br cloud
    - unless: ovs-vsctl list-br | grep "^cloud$"

/etc/sudoers.d/netdriver:
  file.managed:
    - source: salt://vmdriver/files/sudoers
    - template: jinja
    - user: root
    - group: root
    - mode: 600
