include:
  - common

gitrepo_storagedriver:
  git.latest:
    - name: {{ pillar['storagedriver']['repo_name'] }}
    - rev: {{ pillar['storagedriver']['repo_revision'] }}
    - target: /home/{{ pillar['user'] }}/storagedriver
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - require:
      - pkg: git
