ovs-if:
  cmd.run:
    - name: ovs-vsctl add-port cloud vm tag=2 -- set Interface vm type=internal
    - unless: ovs-vsctl list-ifaces cloud | grep "^vm$"

vm:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: {{ pillar['fwdriver']['vm_net_ip'] }}
    - netmask: {{ pillar['fwdriver']['vm_net_mask'] }}
    - pre_up_cmds:
      {% if grains['os_family'] == 'RedHat' %}
      - /bin/systemctl restart openvswitch
      {% elif grains['os'] == 'Debian' %}
      - /bin/systemctl restart openvswitch-switch
      {% else %}  
      - /etc/init.d/openvswitch-switch restart
      {% endif %} 
    - require:
      - cmd: ovs-if

{% if grains['os'] == 'Debian' %}
symlink_dhcpd:
  file.symlink:
    - name: /etc/init.d/dhcpd
    - target: /etc/init.d/isc-dhcp-server
    - force: True
  cmd.run:
    - name: /bin/systemctl daemon-reload
    - require:
      - file: symlink_dhcpd
{% endif %}

firewall2:
  service:
    - name: firewall
    - running
    - require:
      - network: vm

reload_firewall:
  cmd.script:
    - name: salt://network/files/reload_firewall.sh
    - template: jinja
    - user: {{ pillar['user'] }}
    - require:
      - service: firewall2
      {% if grains['os'] == 'Debian' %}
      - cmd: symlink_dhcpd
      {% endif %}

{% if grains['os_family'] == 'RedHat' %}
fix_dhcp:
  cmd.script:
    - name: salt://network/files/fix_dhcp.sh
    - require:
      - cmd: reload_firewall
{% endif %}

isc-dhcp-server:
  {% if grains['os_family'] == 'RedHat' or grains['os'] == 'Debian' %}
  cmd.run:
    - name: /bin/systemctl restart dhcpd
    {% if grains['os_family'] == 'RedHat' %}
    - watch:
      - cmd: fix_dhcp
    {% elif grains['os'] == 'Debian' %}
    - watch:
      - cmd: fix_dhcp_daemon_reload
    {% endif %}
  {% endif %}
  service.running:
    - enable: True
    {% if grains['os_family'] == 'RedHat' %}
    - watch:
      - cmd: fix_dhcp
    {% elif grains['os'] == 'Debian' %}
    - watch:
      - cmd: fix_dhcp_daemon_reload
    {% endif %}
    {% if grains['os_family'] == 'RedHat' or grains['os'] == 'Debian' %}
    - name: dhcpd
    - require:
      - cmd: isc-dhcp-server
    {% endif %}

{% if grains['os'] == 'Debian' %}
{# For next reboot #}
after_openvswitch_conf:
  file.managed:
    - name: /etc/systemd/system/isc-dhcp-server.service.d/after_openvswitch.conf
    - source: salt://network/files/fix_dhcp_Debian.conf
    - user: root
    - group: root
    - template: jinja
    - makedirs: True

fix_dhcp_daemon_reload:
  cmd.run:
    - name: /bin/systemctl daemon-reload
    - require:
      - file: after_openvswitch_conf
{% endif %}
