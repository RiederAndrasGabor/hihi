#!/bin/bash

{% macro open_ports(port_list) -%}
    {% for item in port_list %}
        $ADDRULE\
                 {% if 'range' in item.keys() -%}
                     --port-range {{ item.range[0] }} {{ item.range[1] }}\
                \{% else %}\
                     --port {{ item.port }}\
                 {%- endif %}
                 --protocol {{ item.proto }}\
                 --firewall {{ pillar['fwdriver']['queue_name']  }}\
                 --vlan-group net\
                 --owner {{ pillar['admin_user'] }}
    {% endfor %}
{%- endmacro %}

source /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/activate
source /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/postactivate

ADDRULE="python /home/{{ pillar['user'] }}/circle/circle/manage.py add_rule"


# RabbitMQ ports
{{ open_ports(pillar['rabbitmq_ports']) }}

# libvirt ports
{{ open_ports(pillar['libvirt_ports']) }}

# NFS server ports
{{ open_ports(pillar['nfs_server_ports']) }}

# VXLAN port
{% set vxlan_port = (pillar["network"]["vxlan_port"], ) %}
{{ open_ports(vxlan_port) }}
