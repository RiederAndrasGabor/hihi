virtualenv_fwdriver:
  virtualenv.managed:
    - name: /home/{{ pillar['fwdriver']['user'] }}/.virtualenvs/fw
    - requirements: /home/{{ pillar['fwdriver']['user'] }}/fwdriver/requirements/production.txt
    - user: {{ pillar['fwdriver']['user'] }}
    - no_chown: true
    {% if grains["osfinger"] == "Ubuntu-16.04" %}
    - require:
      - file: ubuntu_virtualenvwrapper
    {% endif %}
