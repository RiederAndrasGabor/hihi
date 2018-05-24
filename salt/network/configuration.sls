{% if pillar["network"]["vxlan_base"] == True %}

{% set vxlan_port =  pillar["network"]["vxlan_port"]["port"] %}
{% set vxlan_proto = pillar["network"]["vxlan_port"]["proto"] %}

open_vxlan_port:
  cmd.run:
    {% if grains['os_family'] == 'RedHat' %}
    - name: >
        firewall-cmd --complete-reload ;
        firewall-cmd --permanent --zone=public --add-port={{ vxlan_port }}/{{ vxlan_proto }} ;
        firewall-cmd --reload
    {% else %}
    - name: ufw allow {{ vxlan_port }}/{{ vxlan_proto }}
    {% endif %}

{% endif %}
