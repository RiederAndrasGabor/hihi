postactivate:
  file.managed:
      - name: /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/postactivate
      - source: salt://manager/files/postactivate
      - template: jinja
      - user: {{ pillar['user'] }}
      - mode: 700

/etc/init/portal.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/circle/miscellaneous/portal.conf
  
/etc/init/manager.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/circle/miscellaneous/manager.conf
  
/etc/init/mancelery.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/circle/miscellaneous/mancelery.conf

/etc/init/moncelery.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/circle/miscellaneous/moncelery.conf

/etc/init/slowcelery.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/circle/miscellaneous/slowcelery.conf
