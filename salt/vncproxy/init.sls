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
      - gitrepo: gitrepo_vncproxy
      - gitrepo: virtualenv_vncproxy
  service:
    - running
