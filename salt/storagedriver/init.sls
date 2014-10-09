include:
  - storagedriver.gitrepo
  - storagedriver.virtualenv
  - storagedriver.configuration
  - storagedriver.nfs-server 

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
      - git: gitrepo_storagedriver
      - virtualenv: virtualenv_storagedriver

storage:
  service:
    - running
    - watch:
      - pkg: storagedriver
      - sls: storagedriver.gitrepo
      - sls: storagedriver.virtualenv
      - sls: storagedriver.configuration
