/home/{{ pillar['user'] }}/.virtualenvs/storagedriver/bin/postactivate:
  file.managed:
    - source: salt://storagedriver/files/postactivate
    - template: jinja
    - user: {{ pillar['user'] }}
    - mode: 700

/etc/init/storagecelery.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/storagedriver/miscellaneous/storagecelery.conf

/etc/init/storage.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/storagedriver/miscellaneous/storage.conf

/datastore:
  file.directory:
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - mode: 755
