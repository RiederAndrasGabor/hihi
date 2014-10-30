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
      - zlib1g-dev
      - qemu-utils
    - require_in:
      - gitrepo: gitrepo_storagedriver
      - virtualenv: virtualenv_storagedriver

storage:
  service:
    - running
