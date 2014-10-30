include:
  - vncproxy.gitrepo
  - vncproxy.virtualenv
  - vncproxy.configuration

vncproxy:
  pkg.installed:
    - pkgs:
      - virtualenvwrapper
      - git
      - python-pip
      - ntp
      - wget
      - libffi-dev
      - libssl-dev
    - require_in:
      - git: gitrepo_vncproxy
      - virtualenv: virtualenv_vncproxy
  service:
    - running
    - watch:
      - pkg: vncproxy
      - sls: vncproxy.gitrepo
      - sls: vncproxy.virtualenv
      - sls: vncproxy.configuration
