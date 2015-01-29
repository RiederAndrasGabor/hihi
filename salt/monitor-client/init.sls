include:
  - monitor-client.gitrepo
  - monitor-client.virtualenv
  - monitor-client.configuration

monitor-client:
  pkg.installed:
    - pkgs:
      - virtualenvwrapper
      - git
      - python-pip
      - ntp
      - wget
      - python-dev
    - require_in:
      - git: gitrepo_monitor-client
      - virtualenv: virtualenv_monitor-client
  service:
    - running
    - watch:
      - pkg: monitor-client
      - sls: monitor-client.gitrepo
      - sls: monitor-client.virtualenv
      - sls: monitor-client.configuration
