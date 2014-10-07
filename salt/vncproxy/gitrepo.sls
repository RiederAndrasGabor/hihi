git:
  pkg.installed

gitrepo:
  git.latest:
    - name: {{ pillar['vncproxy']['repo_name']  }} 
    - rev: {{ pillar['vncproxy']['repo_revision']  }}
    - target: /home/{{ pillar['user'] }}/vncproxy
    - require:
      - pkg: git
