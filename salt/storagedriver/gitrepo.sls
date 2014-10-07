git:
  pkg.installed

gitrepo:
  git.latest:
    - name: {{ pillar['storagedriver']['repo_name']  }} 
    - rev: {{ pillar['storagedriver']['repo_revision']  }}
    - target: /home/{{ pillar['user'] }}/storagedriver
    - require:
      - pkg: git
