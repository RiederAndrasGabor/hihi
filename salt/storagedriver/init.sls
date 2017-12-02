include:
  - storagedriver.gitrepo
  - storagedriver.virtualenv
  - storagedriver.configuration
  - storagedriver.nfs-server 


{% if grains['os_family'] == 'RedHat' %}
ev_repo_for_storagedriver:
  pkg.installed:
    - name: centos-release-qemu-ev
{% endif %}

storagedriver:
  pkg.installed:
    - pkgs:
      - git
      - ntp
      {% if grains['os_family'] == 'RedHat' %}
      - python2-pip
      - libmemcached-devel
      - python-devel
      - python-virtualenvwrapper
      - qemu-img-ev
      - zlib-devel
      {% else %}
      - python-pip
      - libmemcached-dev
      - python-dev
      - qemu-utils
      - virtualenvwrapper
      - zlib1g-dev
      {% endif %}
    - require_in:
      - git: gitrepo_storagedriver
      - virtualenv: virtualenv_storagedriver
    {% if grains['os_family'] == 'RedHat' %}
    - require:
      - pkg: ev_repo_for_storagedriver
    {% endif %}

storage:
  service:
    - running
    - enable: True
    - watch:
      - pkg: storagedriver
      - sls: storagedriver.gitrepo
      - sls: storagedriver.virtualenv
      - sls: storagedriver.configuration
