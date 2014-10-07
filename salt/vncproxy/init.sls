include:
  - vncproxy.configuration
  - vncproxy.gitrepo
  - vncproxy.virtualenv

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
      - sls: gitrepo
      - sls: virtualenv
  service:
    - running
