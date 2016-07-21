virtualenv_agentdriver:
  virtualenv.managed:
    - name: /home/{{ pillar['user'] }}/.virtualenvs/agentdriver
    - requirements: /home/{{ pillar['user'] }}/agentdriver/requirements.txt
    - user: {{ pillar['user'] }}
    - no_chown: true
    {% if grains["osfinger"] == "Ubuntu-16.04" %}
    - require:
      - file: ubuntu_virtualenvwrapper
    {% endif %}
