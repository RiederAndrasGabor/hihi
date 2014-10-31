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

libvirt-bin:
  service:
    - running
    - watch:
      - file: /etc/default/libvirt-bin
      - augeas: libvirtconf

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
