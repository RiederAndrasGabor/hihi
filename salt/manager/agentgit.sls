include:
  - common

agentgit:
  git.latest:
    - name: {{ pillar['agent']['repo_name']  }} 
    - rev: {{ pillar['agent']['repo_revision']  }}
    - target: /home/{{ pillar['user'] }}/agent/agent-linux
    - user: {{ pillar['user'] }}
    - require:
      - pkg: git
