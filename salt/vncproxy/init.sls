include:
  - vncproxy.gitrepo
  - vncproxy.virtualenv
  - vncproxy.configuration

vncproxy:
  pkg.installed:
    - pkgs:
      - git
      - ntp
      - wget
      {% if grains['os_family'] == 'RedHat' %}
      - python2-pip
      - libffi-devel
      - openssl-devel
      - python-devel
      - python-virtualenvwrapper
      {% else %}
      - python-pip
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
