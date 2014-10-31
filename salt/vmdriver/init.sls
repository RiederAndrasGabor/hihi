include:
  - vmdriver.libvirt
  - vmdriver.gitrepo
  - vmdriver.virtualenv
  - vmdriver.configuration

vmdriver:
  pkg.installed:
    - pkgs:
      - virtualenvwrapper
      - git
      - python-pip
      - python-dev
      - python-augeas
      - ntp
      - wget
      - openvswitch-common
      - openvswitch-switch
      - openvswitch-controller
      - libvirt-bin
      - python-libvirt
      - libxml2-dev
      - libmemcached-dev
      - libxslt1-dev
      - zlib1g-dev
      - qemu-kvm
      - qemu-utils
    - require_in:
      - file: /etc/default/libvirt-bin
      - file: /etc/apparmor.d/libvirt/TEMPLATE
      - file: /etc/apparmor.d/usr.lib.libvirt.virt-aa-helper
      - file: /var/lib/libvirt/serial
      - augeas: libvirtconf
      - service: libvirt-bin
      - git: gitrepo_vmdriver
      - virtualenv: virtualenv_vmdriver
node:
  service:
    - running
    - watch:
      - pkg: vmdriver
      - sls: vmdriver.gitrepo
      - sls: vmdriver.virtualenv
      - sls: vmdriver.configuration
