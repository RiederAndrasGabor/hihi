/home/{{ pillar['user'] }}/.virtualenvs/storagedriver/bin/postactivate:
  file.managed:
    - source: salt://storagedriver/files/postactivate
    - template: jinja
    - user: {{ pillar['user'] }}
    - mode: 700

/etc/init/storagecelery.conf:
  file.copy:
    - user: root
    - group: root
    - source: /home/{{ pillar['user'] }}/storagedriver/miscellaneous/storagecelery.conf

/etc/init/storage.conf:
  file.copy:
    - user: root
    - group: root
    - source: /home/{{ pillar['user'] }}/storagedriver/miscellaneous/storage.conf

/datastore:
  file.directory:
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - mode: 755
