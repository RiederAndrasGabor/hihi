include:
  - fwdriver.gitrepo
  - fwdriver.virtualenv
  - fwdriver.configuration

firewall:
  pkg.installed:
    - pkgs:
      - virtualenvwrapper
      - git
      - python-pip
      - python-dev
      - libmemcached-dev
      - ntp
      - openvswitch-switch
      - openvswitch-controller
      - iptables
      - ipset
      - isc-dhcp-server
    - require:
      - user: {{ pillar['fwdriver']['user'] }}
    - require_in:
      - git: gitrepo_fwdriver
      - virtualenv: virtualenv_fwdriver
      - service: isc-dhcp-server
  user:
    - present
    - name: {{ pillar['fwdriver']['user'] }}
    - gid_from_name: True
  service:
    - running
    - require:
      - service: firewall-init
    - watch:
      - pkg: firewall
      - sls: fwdriver.gitrepo
      - sls: fwdriver.virtualenv
      - sls: fwdriver.configuration

firewall-init:
  service:
    - running

