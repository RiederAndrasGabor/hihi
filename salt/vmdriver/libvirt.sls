libvirtconf:
  augeas.setvalue:
    - prefix: /files/etc/libvirt/libvirtd.conf
    - changes:
      - listen_tcp: 1
      - listen_tls: 0
      - auth_tcp: "none"

/etc/default/libvirt-bin:
  file.append:
    - text: libvirtd_opts="-d -l"

{% if grains['os_family'] == 'RedHat' %}
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
