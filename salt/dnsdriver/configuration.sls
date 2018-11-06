/var/lib/circle/dnsdriver:
  file.directory:
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - mode: 755
    - makedirs: True


/var/lib/circle/dnsdriver/makefile:
  file.managed:
    - source: salt://dnsdriver/files/makefile
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - mode: 755


/etc/systemd/system/dnscelery.service:
  file.managed:
    - source: salt://dnsdriver/files/dnscelery.service
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - mode: 755
    - template: jinja


/home/{{ pillar['user'] }}/.virtualenvs/dnsdriver/bin/postactivate:
  file.managed:
    - source: salt://dnsdriver/files/postactivate
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - mode: 755
    - template: jinja
    - require:
       - virtualenv: virtualenv_dnsdriver

tinydns_conf:
  file.managed:
    - name: /etc/ndjbdns/tinydns.conf
    - source: salt://dnsdriver/files/tinydns.conf
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - mode: 755
    - template: jinja
