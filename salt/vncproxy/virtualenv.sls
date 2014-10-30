virtualenv_vncproxy:
  virtualenv.managed:
    - name: /home/{{ pillar['user'] }}/.virtualenvs/vncproxy
    - requirements: /home/{{ pillar['user'] }}/vncproxy/requirements.txt
    - runas: {{ pillar['user'] }}
    - no_chown: true
