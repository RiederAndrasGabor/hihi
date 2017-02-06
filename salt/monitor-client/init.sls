include:
  - monitor-client.gitrepo
  - monitor-client.virtualenv
  - monitor-client.configuration

monitor-client:
  pkg.installed:
    - pkgs:
      - git
      - ntp
      - wget
      {% if grains['os_family'] == 'RedHat' %}
      - python2-pip
      - python-devel
      - python-virtualenvwrapper
      {% else %}
      - python-pip
      - python-dev
      - virtualenvwrapper
      {% endif %}
    - require_in:
      - git: gitrepo_monitor-client
      - virtualenv: virtualenv_monitor-client
  service:
    - running
    - enable: True
    - watch:
      - pkg: monitor-client
      - sls: monitor-client.gitrepo
      - sls: monitor-client.virtualenv
      - sls: monitor-client.configuration
