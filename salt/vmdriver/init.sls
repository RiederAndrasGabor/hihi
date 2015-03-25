include:
  - vmdriver.libvirt
  - vmdriver.gitrepo
  - vmdriver.virtualenv
  - vmdriver.configuration

vmdriver:
  pkg.installed:
    - pkgs:
      - git
      - python-pip
      - python-augeas
      - ntp
      - wget
      - qemu-kvm
      {% if grains['os_family'] == 'RedHat' %}
      - libmemcached-devel
      - libvirt
      - libvirt-daemon
      - libvirt-daemon-kvm
      - libvirt-python
      - libxml2-devel
      - libxslt-devel
      - python-devel
      - python-virtualenvwrapper
      - qemu-img
      - zlib-devel
      {% else %}
      - libmemcached-dev
      - libvirt-bin
      - libxml2-dev
      - libxslt1-dev
      - openvswitch-common
      - openvswitch-switch
      - openvswitch-controller
      - python-dev
      - python-libvirt
      - virtualenvwrapper
      - qemu-utils
      - zlib1g-dev
      {% endif %}
    - require_in:
      - file: /etc/default/libvirt-bin
      {% if grains['os_family'] == 'RedHat' %}
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
node:
  service:
    - running
    - enable: True
    - watch:
      - pkg: vmdriver
      - sls: vmdriver.gitrepo
      - sls: vmdriver.virtualenv
      - sls: vmdriver.configuration
