include:
  - common

# m2crypto workaround
# /usr/include/openssl/opensslconf.h:31: Error: CPP #error
# ""This openssl-devel package does not work your architecture?"".
# Use the -cpperraswarn option to continue swig processing.

{% if grains['os_family'] == 'RedHat' %}
m2crypto_swig_env:
  environ.setenv:
    - name: SWIG_FEATURES
    - value: -D__x86_64__
{% endif %}

virtualenv_manager:
  virtualenv.managed:
    - name: /home/{{ pillar['user'] }}/.virtualenvs/circle
    - requirements: /home/{{ pillar['user'] }}/circle/requirements/{{ pillar['deployment_type'] }}.txt
    - user: {{ pillar['user'] }}
    - no_chown: true
    - require:
      - git: gitrepo
      {% if grains['os_family'] == 'RedHat' %}
      - environ: m2crypto_swig_env
      {% endif %}
      {% if grains["osfinger"] == "Ubuntu-16.04" %}
      - file: ubuntu_virtualenvwrapper
      {% endif %}

salt://manager/files/syncdb.sh:
  cmd.script:
    - template: jinja
    - user: {{ pillar['user'] }}
    - stateful: true
    - require:
      - virtualenv: virtualenv_manager
      - file: /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/postactivate
      - user: {{ pillar['user'] }}

salt://manager/files/compile.sh:
  cmd.script:
    - template: jinja
    - user: {{ pillar['user'] }}
    - stateful: true
    - require:
      - virtualenv: virtualenv_manager
      - file: /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/postactivate
      - user: {{ pillar['user'] }}
