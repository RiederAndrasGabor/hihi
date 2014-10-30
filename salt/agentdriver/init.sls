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
      - gitrepo: gitrepo_agentdriver
      - virtualenv: virtualenv_agentdriver
  service:
    - running
