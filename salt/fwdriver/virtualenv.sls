virtualenv_fwdriver:
  virtualenv.managed:
    - name: /home/{{ pillar['fwdriver']['user'] }}/.virtualenvs/fw
    - requirements: /home/{{ pillar['fwdriver']['user'] }}/fwdriver/requirements.txt
    - runas: {{ pillar['fwdriver']['user'] }}
    - no_chown: true
