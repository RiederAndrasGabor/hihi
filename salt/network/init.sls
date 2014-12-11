ovs-if:
  cmd.run:
    - name: ovs-vsctl add-port cloud man0 tag=3 -- set Interface man0 type=internal
    - unless: ovs-vsctl list-ifaces cloud | grep "^man0$"

linka:
  network.managed:
    - enabled: True
    - type: eth
    - proto: manual
    - pre_up_cmds:
      - ip link add linka type veth peer name linkb
      - /etc/init.d/openvswitch-switch restart
      - /usr/bin/ovs-vsctl --if-exists del-port cloud linka
      - /usr/bin/ovs-vsctl --may-exist add-port cloud linka
      - ip link set linka up
      - ip link set linkb up
    - post_down_cmds:
      - ip link del linka

{{ pillar['fwdriver']['external_if'] }}:
  network.managed:
    - enabled: True
    - type: eth
    - proto: manual

man0:
  network.managed:
    - enabled: True
    - type: eth
    - proto: static
    - ipaddr: {{ pillar['fwdriver']['portal_ip'] }}
    - netmask: {{ pillar['fwdriver']['portal_netmask'] }}
    - gateway: {{ pillar['fwdriver']['management_net'].split('/')[0] }}
    - dns:
      - 8.8.8.8
      - 8.8.4.4
    - pre_up_cmds:
      - /etc/init.d/openvswitch-switch restart
    - require:
      - cmd: ovs-if

firewall2:
  service:
    - name: firewall
    - running
    - require:
      - network: man0

salt://network/files/reload_firewall.sh:
  cmd.script:
    - template: jinja
    - user: {{ pillar['user'] }}
    - require:
      - service: firewall2
      - network: linka
