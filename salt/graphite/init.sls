include:
  - graphite.rabbitmq
  - graphite.virtualenv
  - graphite.configuration

graphite:
  pkg.installed:
    - pkgs:
      - git
      - ntp
      {% if grains['os_family'] == 'RedHat' %}
      - python2-pip
      - pycairo
      - python-devel
      - python-virtualenvwrapper
      - dejavu-sans-fonts
      {% else %}
      - python-pip
      - python-cairo
      - python-dev
      - virtualenvwrapper
      {% endif %}
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
    - enable: True

graphite-carbon:
  service:
    - running
    - enable: True
