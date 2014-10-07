virtualenv:
  virtualenv.managed:
    - name: /home/{{ pillar['user'] }}/.virtualenvs/agentdriver
    - requirements: /home/{{ pillar['user'] }}/agentdriver/requirements.txt

