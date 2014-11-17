/home/{{ pillar['fwdriver']['user'] }}/.virtualenvs/fw/bin/postactivate:
  file.managed:
    - source: salt://fwdriver/files/postactivate
    - template: jinja
    - user: {{ pillar['fwdriver']['user'] }}
    - group: {{ pillar['fwdriver']['user'] }}
    - mode: 700

/etc/init/firewall.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['fwdriver']['user'] }}/fwdriver/miscellaneous/firewall.conf

/etc/init/firewall-init.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['fwdriver']['user'] }}/fwdriver/miscellaneous/firewall-init.conf

/etc/dhcp/dhcpd.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: salt://fwdriver/files/dhcpd.conf

/etc/dhcp/dhcpd.conf.generated:
  file.managed:
    - user: {{ pillar['fwdriver']['user'] }}
    - group: {{ pillar['fwdriver']['user'] }}

/etc/init/isc-dhcp-server.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: salt://fwdriver/files/isc-dhcp-server.conf

/etc/init.d/isc-dhcp-server:
  file.symlink:
    - target: /lib/init/upstart-job
    - force: True

isc-dhcp-server:
  service:
    - running
    - watch:
      - file: /etc/dhcp/dhcpd.conf
      - file: /etc/dhcp/dhcpd.conf.generated
      - file: /etc/init/isc-dhcp-server.conf
      - file: /etc/init.d/isc-dhcp-server

/etc/sysctl.d/60-circle-firewall.conf:
  file.managed:
    - user: root
    - group: root
    - contents: "net.ipv4.ip_forward=1\nnet.ipv6.conf.all.forwarding=1"

/etc/sudoers.d/fwdriver:
  file.managed:
    - user: root
    - group: root
    - mode: 400
    - template: jinja
    - source: salt://fwdriver/files/sudoers
