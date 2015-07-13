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
      - openvswitch-controller
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

