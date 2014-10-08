virtualenv:
  virtualenv.managed:
    - name: /home/{{ pillar['graphite']['user'] }}/.virtualenvs/graphite
    - requirements: /home/{{ pillar['graphite']['user'] }}/requirements.txt
    - runas: {{ pillar['graphite']['user'] }}
    - require:
      - user: {{ pillar['graphite']['user'] }}
      - file: /home/{{ pillar['graphite']['user'] }}/requirements.txt
      - file: /opt/graphite

global-site-packages:
  file.absent:
    - name: /home/{{pillar['graphite']['user'] }}/.virtualenvs/graphite/lib/python2.7/no-global-site-packages.txt
    - require:
      - virtualenv: virtualenv

salt://graphite/files/syncdb.sh:
  cmd.script:
    - template: jinja
    - user: {{ pillar['graphite']['user'] }}
    - require:
      - virtualenv: virtualenv
      - user: {{ pillar['graphite']['user'] }}
