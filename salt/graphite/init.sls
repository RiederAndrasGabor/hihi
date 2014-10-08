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
      - sls: virtualenv
  user:
    - present
    - name: {{ pillar['graphite']['user'] }}
    - gid_from_name: True

  service:
    - running
