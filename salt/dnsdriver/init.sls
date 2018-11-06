include:
  - dnsdriver.gitrepo
  - dnsdriver.virtualenv
  - dnsdriver.configuration


dnsdriver:
  pkg.installed:
    - pkgs:
      - ndjbdns
      - make
      - python-virtualenvwrapper
    - require_in:
      - virtualenv: virtualenv_dnsdriver
      - file: tinydns_conf


dnscelery:
  service.running:
    - enable: True
    - watch:
      - pkg: dnsdriver
      - sls: dnsdriver.gitrepo
      - sls: dnsdriver.virtualenv
      - sls: dnsdriver.configuration


tinydns:
  service.running:
    - enable: True
    - watch:
      - pkg: dnsdriver
      - sls: dnsdriver.gitrepo
      - sls: dnsdriver.virtualenv
      - sls: dnsdriver.configuration
