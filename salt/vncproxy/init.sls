include:
  - vncproxy.gitrepo
  - vncproxy.virtualenv
  - vncproxy.configuration

vncproxy:
  pkg.installed:
    - pkgs:
      - git
      - python-pip
      - ntp
      - wget
      {% if grains['os_family'] == 'RedHat' %}
      - libffi-devel
      - openssl-devel
      - python-devel
      - python-virtualenvwrapper
      {% else %}
      - libffi-dev
      - libssl-dev
      - python-dev
      - virtualenvwrapper
      {% endif %}
    - require_in:
      - git: gitrepo_vncproxy
      - virtualenv: virtualenv_vncproxy
  service:
    - running
    - enable: True
    - watch:
      - pkg: vncproxy
      - sls: vncproxy.gitrepo
      - sls: vncproxy.virtualenv
      - sls: vncproxy.configuration
