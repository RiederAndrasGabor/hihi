include:
  - storagedriver.gitrepo
  - storagedriver.virtualenv
  - storagedriver.configuration

storagedriver:
  pkg.installed:
    - pkgs:
      - virtualenvwrapper
      - git
      - python-pip
      - python-dev
      - libmemcached-dev
      - ntp
      - qemu-utils
    - require_in:
      - sls: gitrepo
      - sls: virtualenv

storage:
  service:
    - running
