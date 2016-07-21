virtualenv_monitor-client:
  virtualenv.managed:
    - name: /home/{{ pillar['user'] }}/.virtualenvs/monitor-client
    - requirements: /home/{{ pillar['user'] }}/monitor-client/requirements.txt
    - user: {{ pillar['user'] }}
    - no_chown: true
