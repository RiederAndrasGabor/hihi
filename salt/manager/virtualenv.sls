include:
  - common

virtualenv_manager:
  virtualenv.managed:
    - name: /home/{{ pillar['user'] }}/.virtualenvs/circle
    - requirements: /home/{{ pillar['user'] }}/circle/requirements/{{ pillar['deployment_type'] }}.txt
    - runas: {{ pillar['user'] }}
    - cwd: /home/{{ pillar['user'] }}/circle/
    - no_chown: true
    - require:
      - git: gitrepo

salt://manager/files/syncdb.sh:
  cmd.script:
    - template: jinja
    - user: {{ pillar['user'] }}
    - stateful: true
    - require:
      - virtualenv: virtualenv_manager
      - file: /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/postactivate
      - user: {{ pillar['user'] }}

salt://manager/files/compile.sh:
  cmd.script:
    - template: jinja
    - user: {{ pillar['user'] }}
    - stateful: true
    - require:
      - virtualenv: virtualenv_manager
      - file: /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/postactivate
      - user: {{ pillar['user'] }}
