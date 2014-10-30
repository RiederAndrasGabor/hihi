include:
  - graphite.rabbitmq
  - graphite.virtualenv
  - graphite.configuration

graphite:
  pkg.installed:
    - pkgs:
      - virtualenvwrapper
      - git
      - python-pip
      - ntp
      - python-cairo
    - require:
      - user: {{ pillar['graphite']['user'] }}
    - require_in:
      - virtualenv: virtualenv_graphite
      - service: graphite
      - service: graphite-carbon
  user:
    - present
    - name: {{ pillar['graphite']['user'] }}
    - gid_from_name: True

  service:
    - running

graphite-carbon:
  service:
    - running
