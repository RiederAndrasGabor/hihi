include:
  - common

virtualenv_manager:
  virtualenv.managed:
    - name: /home/{{ pillar['user'] }}/.virtualenvs/circle
    - requirements: /home/{{ pillar['user'] }}/circle/requirements/test.txt
    - runas: {{ pillar['user'] }}
    - cwd: /home/{{ pillar['user'] }}/circle/
    - no_chown: true
    - require:
      - git: gitrepo

salt://manager/files/syncdb.sh:
  cmd.script:
    - template: jinja
    - user: {{ pillar['user'] }}
    - require:
      - virtualenv: virtualenv_manager
      - file: /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/postactivate
      - user: {{ pillar['user'] }}

salt://manager/files/compile.sh:
  cmd.script:
    - template: jinja
    - user: {{ pillar['user'] }}
    - require:
      - virtualenv: virtualenv_manager
      - file: /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/postactivate
      - user: {{ pillar['user'] }}
