include:
  - common

gitrepo_agentdriver:
  git.latest:
    - name: {{ pillar['agentdriver']['repo_name'] }}
    - rev: {{ pillar['agentdriver']['repo_revision'] }}
    - target: /home/{{ pillar['user'] }}/agentdriver
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - require:
      - pkg: git
