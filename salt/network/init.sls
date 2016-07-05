include:
  - openvswitch


ovs-bridge:
  openvswitch_bridge.present:
    - name: cloud

{% if grains['os_family'] == 'RedHat' %}
net_config:
  file.managed:
    - name: /etc/sysconfig/network
    - source: salt://network/files/network
    - user: root
    - group: root
    - mode: 644
{% endif %}
