virtualenv_graphite:
  virtualenv.managed:
    - name: /opt/graphite/
    - system_site_packages: False
    - user: {{ pillar['graphite']['user'] }}

pip_graphite:
  pip.installed:
    - bin_env: /opt/graphite/bin/pip
    - requirements: /home/{{ pillar['graphite']['user'] }}/requirements.txt
    - user: {{ pillar['graphite']['user'] }}
    - install_options:
      - --prefix=/opt/graphite
    - require:
      - virtualenv_graphite
      - user: {{ pillar['graphite']['user'] }}
      - file: /home/{{ pillar['graphite']['user'] }}/requirements.txt
      - file: /opt/graphite
    - env_vars:
        PYTHONPATH: '/opt/graphite/lib/:/opt/graphite/webapp/'

salt://graphite/files/syncdb.sh:
  cmd.script:
    - template: jinja
    - user: {{ pillar['graphite']['user'] }}
    - require:
      - virtualenv: virtualenv_graphite
      - user: {{ pillar['graphite']['user'] }}
