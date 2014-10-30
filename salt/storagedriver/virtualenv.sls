virtualenv_storagedriver:
  virtualenv.managed:
    - name: /home/{{ pillar['user'] }}/.virtualenvs/storagedriver
    - requirements: /home/{{ pillar['user'] }}/storagedriver/requirements/production.txt

