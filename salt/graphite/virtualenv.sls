graphite_carbon:
  pkg.installed:
  {% if grains['os_family'] == 'RedHat' %}
    - name: python-carbon
  {% else %}
    - name: graphite-carbon
  {% endif %}

virtualenv_graphite:
  virtualenv.managed:
    - name: /home/{{ pillar['graphite']['user'] }}/.virtualenvs/graphite
    - requirements: /home/{{ pillar['graphite']['user'] }}/requirements.txt
    - user: {{ pillar['graphite']['user'] }}
    - require:
      - user: {{ pillar['graphite']['user'] }}
      - file: /home/{{ pillar['graphite']['user'] }}/requirements.txt
      - file: /opt/graphite

global-site-packages:
  file.absent:
    - name: /home/{{pillar['graphite']['user'] }}/.virtualenvs/graphite/lib/python2.7/no-global-site-packages.txt
    - require:
      - virtualenv: virtualenv_graphite

unicode-fix-diff:
  file.managed:
    - name: /home/{{pillar['graphite']['user'] }}/graphite-unicode-fix.diff
    - template: jinja
    - source: salt://graphite/files/graphite-unicode-fix.diff
    - user: {{ pillar['graphite']['user'] }}
    - group: {{ pillar['graphite']['user'] }}

unicode-fix:
  cmd.run:
    - user: {{ pillar['graphite']['user'] }}
    - cwd: /opt/graphite/webapp/graphite
    - name: patch -N -p1 < /home/{{pillar['graphite']['user'] }}/graphite-unicode-fix.diff
    - onlyif: patch -N --dry-run --silent -p1 < /home/{{pillar['graphite']['user'] }}/graphite-unicode-fix.diff
    - require:
      - virtualenv: virtualenv_graphite
      - user: {{ pillar['graphite']['user'] }}
      - file: unicode-fix-diff

salt://graphite/files/syncdb.sh:
  cmd.script:
    - template: jinja
    - user: {{ pillar['graphite']['user'] }}
    - require:
      - virtualenv: virtualenv_graphite
      - user: {{ pillar['graphite']['user'] }}
