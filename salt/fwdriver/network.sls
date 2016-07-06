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


{# -- DHCP server configuration -- #}

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

{% if grains['os_family'] == 'RedHat' %}
fix_dhcp:
  cmd.script:
    - name: salt://fwdriver/files/fix_dhcp.sh
{% endif %}

{% if grains['os'] == 'Debian' %}
{# For next reboot #}
after_openvswitch_conf:
  file.managed:
    - name: /etc/systemd/system/isc-dhcp-server.service.d/after_openvswitch.conf
    - source: salt://fwdriver/files/fix_dhcp_Debian.conf
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
