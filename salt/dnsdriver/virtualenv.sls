virtualenv_dnsdriver:
  virtualenv.managed:
    - name: /home/{{ pillar['user'] }}/.virtualenvs/dnsdriver
    - requirements: /home/{{ pillar['user'] }}/dnsdriver/requirements.txt
    - user: {{ pillar['user'] }}
    - no_chown: true
    - require:
      - git: gitrepo_dnsdriver
