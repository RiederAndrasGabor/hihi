include:
  - fwdriver.gitrepo
  - fwdriver.virtualenv
  - fwdriver.configuration

firewall:
  pkg.installed:
    - pkgs:
      {% if grains['os_family'] == 'RedHat' %}
      - zlib-devel
      - python-virtualenvwrapper
      - python-devel
      - libmemcached-devel
      - dhcp
      {% else  %}
      - zlib1g-dev
      - virtualenvwrapper
      - python-dev
      - libmemcached-dev
      - openvswitch-switch
      {% if grains['os'] != 'Debian' %}
      {# No such package in Debian Jessie! #}
      - openvswitch-controller
      {% endif %}
      - isc-dhcp-server
      {% endif %}
      - git
      - python-pip
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

