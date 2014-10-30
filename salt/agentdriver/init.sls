include:
  - agentdriver.gitrepo
  - agentdriver.virtualenv
  - agentdriver.configuration

agentdriver:
  pkg.installed:
    - pkgs:
      - virtualenvwrapper
      - git
      - python-pip
      - ntp
      - incron
      - libmemcached-dev
      - zlib1g-dev
    - require_in:
      - git: gitrepo_agentdriver
      - virtualenv: virtualenv_agentdriver
  service:
    - running
    - watch:
      - pkg: agentdriver
      - sls: agentdriver.gitrepo
      - sls: agentdriver.virtualenv
      - sls: agentdriver.configuration
