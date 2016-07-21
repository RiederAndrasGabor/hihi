virtualenv_storagedriver:
  virtualenv.managed:
    - name: /home/{{ pillar['user'] }}/.virtualenvs/storagedriver
    - requirements: /home/{{ pillar['user'] }}/storagedriver/requirements/production.txt
    - user: {{ pillar['user'] }}
    - no_chown: true
    - require:
      - pkg: storagedriver
      {% if grains["osfinger"] == "Ubuntu-16.04" %}
      - file: ubuntu_virtualenvwrapper
      {% endif %}
