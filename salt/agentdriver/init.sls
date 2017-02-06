include:
  - agentdriver.gitrepo
  - agentdriver.virtualenv
  - agentdriver.configuration

agentdriver:
  pkg.installed:
    - pkgs:
      - git
      - ntp
      - incron
      {% if grains['os_family'] == 'RedHat' %}
      - python2-pip
      - libmemcached-devel
      - python-devel
      - python-virtualenvwrapper
      - zlib-devel
      {% else %}
      - libmemcached-dev
      - python-dev
      - virtualenvwrapper
      - python-pip
      - zlib1g-dev
      {% endif %}
    - require_in:
      - git: gitrepo_agentdriver
      - virtualenv: virtualenv_agentdriver
  user:
    - present
    - name: {{ pillar['user'] }}
    - gid_from_name: True
    - shell: /bin/bash
    - groups:
      {% if grains['os_family'] == 'RedHat' %}
      - wheel
      {% else %}
      - sudo
      {% endif %}
    - require_in:
      - git: gitrepo_agentdriver
      - virtualenv: virtualenv_agentdriver

