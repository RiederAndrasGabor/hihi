include:
  - common

gitrepo_monitor-client:
  git.latest:
    - name: {{ pillar['monitor-client']['repo_name'] }}
    - rev: {{ pillar['monitor-client']['repo_revision'] }}
    - target: /home/{{ pillar['user'] }}/monitor-client
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - require:
      - pkg: git
