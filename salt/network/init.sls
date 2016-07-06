include:
  - openvswitch


ovs-bridge:
  openvswitch_bridge.present:
    - name: cloud

circle-vxlan:
  openvswitch_port.present:
    - bridge: cloud
    - type: vxlan
    - id: 42
    - remote: 239.1.1.1
    - dst_port: 4789
    - require:
      - openvswitch_bridge: ovs-bridge
      - pkg: bind-utils

{% if grains['os_family'] == 'RedHat' %}
net_config:
  file.managed:
    - name: /etc/sysconfig/network
    - source: salt://network/files/network
    - user: root
    - group: root
    - mode: 644
{% endif %}
