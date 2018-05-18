include:
  - vmdriver.libvirt
  - vmdriver.gitrepo
  - vmdriver.virtualenv
  - vmdriver.configuration


{% if grains['os_family'] == 'RedHat' %}
ev_repo_for_vmdriver:
  pkg.installed:
    - name: centos-release-qemu-ev
{% endif %}

vmdriver:
  pkg.installed:
    - pkgs:
      - git
      - python-augeas
      - ntp
      - wget
      {% if grains['os_family'] == 'RedHat' %}
      - qemu-kvm-ev
      - python2-pip
      - libmemcached-devel
      - libvirt
      - libvirt-daemon
      - libvirt-daemon-kvm
      - libvirt-python
      - libxml2-devel
      - libxslt-devel
      - python-devel
      - python-virtualenvwrapper
      - qemu-img-ev
      - zlib-devel
      {% else %}
      - qemu-kvm
      - python-pip
      - libmemcached-dev
      - libvirt-bin
      - libxml2-dev
      - libxslt1-dev
      - openvswitch-common
      - openvswitch-switch
      {% if grains['os'] != 'Debian' and grains['os'] != 'Ubuntu' and grains['oscodename'] != 'xenial' %}
      {# No such package in Debian Jessie! #}
      - openvswitch-controller
      {% endif %}
      - python-dev
      - python-libvirt
      - virtualenvwrapper
      - qemu-utils
      - zlib1g-dev
      {% endif %}
    - require_in:
      - file: /etc/default/libvirt-bin
      {% if grains['os_family'] == 'RedHat' or grains['os'] == 'Debian' %}
      - service: libvirtd
      {% else %}
      - file: /etc/apparmor.d/libvirt/TEMPLATE
      - file: /etc/apparmor.d/usr.lib.libvirt.virt-aa-helper
      - file: /var/lib/libvirt/serial
      - service: libvirt-bin
      {% endif %}
      - augeas: libvirtconf
      - git: gitrepo_vmdriver
      - virtualenv: virtualenv_vmdriver
    {% if grains['os_family'] == 'RedHat' %}
    - require:
      - pkg: ev_repo_for_vmdriver
    {% endif %}

agentdriver_service:
  service:
    - name: agentdriver
    - running
    - enable: true
    - watch:
      - pkg: agentdriver
      - sls: agentdriver.gitrepo
      - sls: agentdriver.virtualenv
      - sls: agentdriver.configuration

node:
  service:
    - running
    - enable: True
    - watch:
      - pkg: vmdriver
      - sls: vmdriver.gitrepo
      - sls: vmdriver.virtualenv
      - sls: vmdriver.configuration
