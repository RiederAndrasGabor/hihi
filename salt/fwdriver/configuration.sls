include:
  - openvswitch

/home/{{ pillar['fwdriver']['user'] }}/.virtualenvs/fw/bin/postactivate:
  file.managed:
    - source: salt://fwdriver/files/postactivate
    - template: jinja
    - user: {{ pillar['fwdriver']['user'] }}
    - group: {{ pillar['fwdriver']['user'] }}
    - mode: 700

{% if grains['os_family'] == 'RedHat' or grains['os'] == 'Debian' %} 
/etc/systemd/system/firewall.service:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['fwdriver']['user'] }}/fwdriver/miscellaneous/firewall.service

/etc/systemd/system/firewall-init.service:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: salt://fwdriver/files/firewall-init.service
{% else %}
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
{% endif %}

/etc/dhcp:
  file.directory:
    - mode: 755

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

{% if grains['os_family'] != 'RedHat' and grains['os'] != 'Debian' %}
/etc/init.d/isc-dhcp-server:
  file.symlink:
    - target: /lib/init/upstart-job
    - force: True
{% endif %}

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


{% if grains['os_family'] == 'RedHat' or grains['os'] == 'Debian' %}
systemd-sysctl:
  cmd.run:
    - name: /bin/systemctl restart systemd-sysctl
  service.running:
    - watch:
      - file: /etc/sysctl.d/60-circle-firewall.conf
    - require:
      - cmd: systemd-sysctl
{% endif %}

{% if grains['os_family'] == 'RedHat' %}
/root/firewall-init.te:
  file.managed:
    - source: salt://fwdriver/files/firewall-init.te
    - template: jinja
    - mode: 644

firewall-init_semodule:
  cmd.run:
    - cwd: /root
    - user: root
    - name: checkmodule -M -m -o firewall-init.mod firewall-init.te; semodule_package -o firewall-init.pp -m firewall-init.mod; semodule -i firewall-init.pp
    - unless: semodule -l |grep -qs ^firewall-init
    - require:
      - file: /root/firewall-init.te

{% endif %}

