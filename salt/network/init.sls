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

firewall2:
  service:
    - name: firewall
    - running
    - require:
      - network: vm

salt://network/files/reload_firewall.sh:
  cmd.script:
    - template: jinja
    - user: {{ pillar['user'] }}
    - require:
      - service: firewall2

{% if grains['os_family'] == 'RedHat' %}
salt://network/files/fix_dhcp.sh:
  cmd.script
{% endif %}

isc-dhcp-server:
  service:
    - running
    {% if grains['os_family'] == 'RedHat' %}
    - name: dhcpd
    {% endif %}
    - enable: True
    - reload: True

{% if grains['os'] == 'Debian' %}
{# For next reboot #}
/etc/systemd/system/isc-dhcp-server.service.d/after_openvswitch.conf:
  file.managed:
    - source: salt://network/files/fix_dhcp_Debian.conf
    - user: root
    - group: root
    - template: jinja
    - makedirs: True
{% endif %}
