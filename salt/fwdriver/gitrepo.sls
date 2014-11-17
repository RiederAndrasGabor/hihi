include:
  - common

gitrepo_fwdriver:
  git.latest:
    - name: {{ pillar['fwdriver']['repo_name'] }}
    - rev: {{ pillar['fwdriver']['repo_revision'] }}
    - target: /home/{{ pillar['fwdriver']['user'] }}/fwdriver
    - user: {{ pillar['fwdriver']['user'] }}
    - group: {{ pillar['fwdriver']['user'] }}
    - require:
      - pkg: git
