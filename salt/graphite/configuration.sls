postactivate:
  file.managed:
      - name: /home/{{ pillar['graphite']['user'] }}/.virtualenvs/graphite/bin/postactivate
      - source: salt://graphite/files/postactivate
      - template: jinja
      - user: {{ pillar['graphite']['user'] }}
      - group: {{ pillar['graphite']['user'] }}
      - mode: 700

requirements:  
  file.managed:
      - name: /home/{{ pillar['graphite']['user'] }}/requirements.txt
      - template: jinja
      - source: salt://graphite/files/requirements.txt
      - user: {{ pillar['graphite']['user'] }}
      - group: {{ pillar['graphite']['user'] }}
      - require:
        - user: {{ pillar['graphite']['user'] }}
  
{% if grains['os_family'] == 'RedHat' %}

/etc/systemd/system/graphite.service:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: salt://graphite/files/graphite.service

/etc/systemd/system/graphite-carbon.service:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: salt://graphite/files/graphite-carbon.service

{% else %}

/etc/init/graphite.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: salt://graphite/files/graphite.conf

/etc/init/graphite-carbon.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: salt://graphite/files/graphite-carbon.conf
{% endif %}

/opt/graphite:
  file.directory:
    - makedirs: True
    - user: {{ pillar['graphite']['user'] }}
    - group: {{ pillar['graphite']['user'] }}
    - require:
      - user: {{ pillar['graphite']['user'] }}

/opt/graphite/conf/carbon.conf:
  file.managed:
    - source: salt://graphite/files/carbon.conf
    - user: {{ pillar['graphite']['user'] }}
    - group: {{ pillar['graphite']['user'] }}
    - template: jinja
    - makedirs: True
    - require:
      - user: {{ pillar['graphite']['user'] }}

/opt/graphite/conf/storage-schemas.conf:
  file.managed:
    - name: /opt/graphite/conf/storage-schemas.conf
    - source: salt://graphite/files/storage-schemas.conf
    - user: {{ pillar['graphite']['user'] }}
    - group: {{ pillar['graphite']['user'] }}
    - makedirs: True
    - require:
      - user: {{ pillar['graphite']['user'] }}

/opt/graphite/webapp/graphite/local_settings.py:
  file.managed:
    - source: salt://graphite/files/local_settings.py
    - user: {{ pillar['graphite']['user'] }}
    - group: {{ pillar['graphite']['user'] }}
    - template: jinja
    - makedirs: True
    - require:
      - user: {{ pillar['graphite']['user'] }}
