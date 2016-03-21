augeas_dependency:
  pkg.installed:
    - pkgs:
      - python-augeas

libvirtconf:
  augeas.change:
    - context: /files/etc/libvirt/libvirtd.conf
    - changes:
      - set listen_tcp 1
      - set listen_tls 0
      - set auth_tcp "none"

/etc/default/libvirt-bin:
  file.append:
    - text: libvirtd_opts="-d -l"

{% if grains['os_family'] == 'RedHat' or grains['os'] == 'Debian' %}
libvirtd:
{% else %}
libvirt-bin:
{% endif %}
  service:
    - running
    - watch:
      - file: /etc/default/libvirt-bin
      - augeas: libvirtconf

{% if grains['os_family'] == 'RedHat' %}
/usr/bin/kvm:
  file.symlink:
    - target: /usr/libexec/qemu-kvm

/etc/polkit-1/rules.d/10.virt.rules:
  file.managed:
    - source: salt://vmdriver/files/10.virt.rules
    - template: jinja
    - mode: 644

polkit:
  service:
    - running
    - watch:
      - file: /etc/polkit-1/rules.d/10.virt.rules

/root/vmdriver.te:
  file.managed:
    - source: salt://vmdriver/files/vmdriver.te
    - template: jinja
    - mode: 644

selinux_pkgs:
  pkg.installed:
    - pkgs:
      - policycoreutils
      - policycoreutils-python

vmdriver_semodule:
  cmd.run:
    - cwd: /root
    - user: root
    - name: checkmodule -M -m -o vmdriver.mod vmdriver.te; semodule_package -o vmdriver.pp -m vmdriver.mod; semodule -i vmdriver.pp
    - unless: semodule -l |grep -qs ^vmdriver
    - require:
      - file: /root/vmdriver.te
      - pkg: selinux_pkgs

{% elif grains['os'] == 'Debian' %}

/usr/bin/kvm:
  file.replace:
    - pattern: -enable-kvm
    - repl: ""
    - watch:
      - pkg: vmdriver

policycoreutils:
  pkg.installed

{# Note: Debian Jessie has polkit 0.105, which uses pkla format instead of js #}
/etc/polkit-1/localauthority/50-local.d/org.libvirt.unix.manage.pkla:
  file.managed:
    - source: salt://vmdriver/files/org.libvirt.unix.manage.pkla
    - user: root
    - group: root
    - template: jinja

polkitd:
  service:
    - running
    - watch:
      - file: /etc/polkit-1/localauthority/50-local.d/org.libvirt.unix.manage.pkla

{% else %}

/etc/apparmor.d/libvirt/TEMPLATE:
  file.managed:
    - source: salt://vmdriver/files/apparmor-libvirt
    - template: jinja
    - mode: 644

/etc/apparmor.d/usr.lib.libvirt.virt-aa-helper:
  file.managed:
    - source: salt://vmdriver/files/usr.lib.libvirt.virt-aa-helper
    - template: jinja
    - mode: 644

apparmor:
  service:
    - reload: true
    - running
    - watch:
      - file: /etc/apparmor.d/libvirt/TEMPLATE
      - file: /etc/apparmor.d/usr.lib.libvirt.virt-aa-helper
{% endif %}

/var/lib/libvirt/serial:
  file.directory:
    - makedirs: True
    {% if grains['os_family'] == 'RedHat' %}
    - user: qemu
    {% else %}
    - user: libvirt-qemu
    {% endif %}
    - group: kvm
    - mode: 755
