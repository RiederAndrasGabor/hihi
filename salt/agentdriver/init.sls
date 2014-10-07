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
  service:
    - running

include:
  - agentdriver.gitrepo
  - agentdriver.virtualenv
  - agentdriver.configuration
