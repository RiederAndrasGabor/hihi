include:
  - fwdriver.gitrepo
  - fwdriver.virtualenv
  - fwdriver.configuration

disable_os_firewall:
  cmd.run:
    {% if grains['os_family'] == 'RedHat' %}
    - name: >
        systemctl disable firewalld ;
        systemctl stop firewalld
    {% else %}
    - name: ufw disable
    {% endif %}

firewall:
  pkg.installed:
    - pkgs:
      {% if grains['os_family'] == 'RedHat' %}
      - zlib-devel
      - python-virtualenvwrapper
      - python-devel
      - libmemcached-devel
      - python2-pip
      - dhcp
      {% else  %}
      - zlib1g-dev
      - virtualenvwrapper
      - python-dev
      - libmemcached-dev
      - openvswitch-switch
      - python-pip
      {% if grains['os'] != 'Debian' %}
      {# No such package in Debian Jessie! #}
      - openvswitch-controller
      {% endif %}
      - isc-dhcp-server
      {% endif %}
      - git
      - ntp
      - iptables
      - ipset
    - require:
      - user: {{ pillar['fwdriver']['user'] }}
    - require_in:
      - git: gitrepo_fwdriver
      - virtualenv: virtualenv_fwdriver

  user:
    - present
    - name: {{ pillar['fwdriver']['user'] }}
    - gid_from_name: True
  service:
    - enabled
    - require:
      - service: firewall-init

firewall-init:
  service:
    - enabled

