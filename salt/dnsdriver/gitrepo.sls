include:
  - common

gitrepo_dnsdriver:
  git.latest:
    - name: {{ pillar['dnsdriver']['repo_name'] }}
    - rev: {{ pillar['dnsdriver']['repo_revision'] }}
    - target: /home/{{ pillar['user'] }}/dnsdriver
    - user: {{ pillar['user'] }}
    - require:
      - pkg: git
