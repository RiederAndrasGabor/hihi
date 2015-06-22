include:
  - common

gitrepo_vmdriver:
  git.latest:
    - name: {{ pillar['vmdriver']['repo_name'] }}
    - rev: {{ pillar['vmdriver']['repo_revision'] }}
    - target: /home/{{ pillar['user'] }}/vmdriver
    - user: {{ pillar['user'] }}
    - require:
      - pkg: git
