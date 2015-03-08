include:
  - storagedriver.gitrepo
  - storagedriver.virtualenv
  - storagedriver.configuration
  - storagedriver.nfs-server 

storagedriver:
  pkg.installed:
    - pkgs:
      - git
      - python-pip
      - ntp
      {% if grains['os_family'] == 'RedHat' %}
      - libmemcached-devel
      - python-devel
      - python-virtualenvwrapper
      - qemu-img
      - zlib-devel
      {% else %}
      - libmemcached-dev
      - python-dev
      - qemu-utils
      - virtualenvwrapper
      - zlib1g-dev
      {% endif %}
    - require_in:
      - git: gitrepo_storagedriver
      - virtualenv: virtualenv_storagedriver

storage:
  service:
    - running
    - enable: True
    - watch:
      - pkg: storagedriver
      - sls: storagedriver.gitrepo
      - sls: storagedriver.virtualenv
      - sls: storagedriver.configuration
