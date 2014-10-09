postactivate:
  file.managed:
      - name: /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/postactivate
      - source: salt://manager/files/postactivate
      - template: jinja
      - user: {{ pillar['user'] }}
      - mode: 700

/etc/init/portal.conf:
  file.copy:
    - user: root
    - group: root
    - source: /home/{{ pillar['user'] }}/circle/miscellaneous/portal.conf
  
/etc/init/manager.conf:
  file.copy:
    - user: root
    - group: root
    - source: /home/{{ pillar['user'] }}/circle/miscellaneous/manager.conf
  
/etc/init/mancelery.conf:
  file.copy:
    - user: root
    - group: root
    - source: /home/{{ pillar['user'] }}/circle/miscellaneous/mancelery.conf

/etc/init/moncelery.conf:
  file.copy:
    - user: root
    - group: root
    - source: /home/{{ pillar['user'] }}/circle/miscellaneous/moncelery.conf

/etc/init/slowcelery.conf:
  file.copy:
    - user: root
    - group: root
    - source: /home/{{ pillar['user'] }}/circle/miscellaneous/slowcelery.conf
