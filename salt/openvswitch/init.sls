bind-utils:  # for salt.states.openvswitch_port module
  pkg.installed:
    {% if grains['os_family'] == "RedHat" %}
    - name: bind-utils
    {% else %}
    - name: dnsutils
    {% endif %}

{% if grains['os_family'] == "RedHat" %}
openvswitch:
  pkg.installed:
    - sources:
      - openvswitch: salt://openvswitch/files/openvswitch-2.3.1-1.x86_64.rpm
  cmd.run:
    - name: mkdir /etc/openvswitch; restorecon -R /etc/openvswitch/
    - creates: /etc/openvswitch
    - require:
      - pkg: openvswitch
  service:
    - name: openvswitch
    - running
    - enable: True
    - require:                                                                                   
      - cmd: openvswitch                                                                         
    - required_in:
      - cmd: ovs-bridge
{% endif %}
