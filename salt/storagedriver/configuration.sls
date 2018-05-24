/home/{{ pillar['user'] }}/.virtualenvs/storagedriver/bin/postactivate:
  file.managed:
    - source: salt://storagedriver/files/postactivate
    - template: jinja
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - mode: 700

{% if grains['os_family'] == 'RedHat' or grains['os'] == 'Debian' or grains['os'] == 'Ubuntu' and grains['oscodename'] == 'xenial' %}
/etc/systemd/system/storagecelery@.service:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/storagedriver/miscellaneous/storagecelery@.service

/etc/systemd/system/storage.service:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/storagedriver/miscellaneous/storage.service

{% else %}

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
{% endif %}

/datastore:
  file.directory:
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - mode: 755

# will not be needed in the future, with new gc
/datastore/trash:
  file.directory:
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - mode: 755
    - require:
      - file: /datastore
