include:
  - openvswitch
  - network.configuration

ovs-bridge:
  openvswitch_bridge.present:
    - name: cloud

{% set net = pillar["network"] %}
{% if net["vxlan_base"] == True %}
circle-vxlan-if:
  cmd.run:
    - name: >
        ip link add {{ net["vxlan_name"] }} type vxlan id {{ net["vxlan_id"] }} group 239.1.1.1 dev {{ net["if_name"] }} dstport {{ net["vxlan_port"]["port"] }} ;
        ip link set {{ net["vxlan_name"] }} up
    - unless: ip link show {{ net["vxlan_name"] }} | grep "{{ net["vxlan_name"] }}"

circle-vxlan:
  openvswitch_port.present:
    - name: {{ net["vxlan_name"] }}
    - bridge: cloud
    - require:
      - openvswitch_bridge: ovs-bridge
      - pkg: bind-utils
      - cmd: circle-vxlan-if
{% endif %}

{% if grains['os_family'] == 'RedHat' %}
net_config:
  file.managed:
    - name: /etc/sysconfig/network
    - source: salt://network/files/network
    - user: root
    - group: root
    - mode: 644
{% endif %}
