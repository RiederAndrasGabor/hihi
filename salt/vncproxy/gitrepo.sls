include:
  - common

gitrepo_vncproxy:
  git.latest:
    - name: {{ pillar['vncproxy']['repo_name'] }}
    - rev: {{ pillar['vncproxy']['repo_revision'] }}
    - target: /home/{{ pillar['user'] }}/vncproxy
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - require:
      - pkg: git
