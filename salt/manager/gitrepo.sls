include:
  - common

gitrepo:
  git.latest:
    - name: {{ pillar['manager']['repo_name']  }} 
    - rev: {{ pillar['manager']['repo_revision']  }}
    - target: /home/{{ pillar['user'] }}/circle
    - user: {{ pillar['user'] }}
    - require:
      - pkg: git
