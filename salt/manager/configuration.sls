manager_postactivate:
  file.managed:
      - name: /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/postactivate
      - source: salt://manager/files/postactivate
      - template: jinja
      - user: {{ pillar['user'] }}
      - mode: 700

portal.conf:
  file.managed:
{% if pillar['deployment_type'] == 'production' %}
    - name: /etc/init/portal-uwsgi.conf
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/circle/miscellaneous/portal-uwsgi.conf
{% else %}
    - name: /etc/init/portal.conf
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/circle/miscellaneous/portal.conf
{% endif %}
  
/etc/init/manager.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/circle/miscellaneous/manager.conf
  
/etc/init/mancelery.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/circle/miscellaneous/mancelery.conf

/etc/init/moncelery.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/circle/miscellaneous/moncelery.conf

/etc/init/slowcelery.conf:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/circle/miscellaneous/slowcelery.conf

salt://manager/files/init.sh:
  cmd.script:
    - template: jinja
    - user: {{ pillar['user'] }}
    - stateful: true
    - require:
      - virtualenv: virtualenv_manager
      - file: /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/postactivate
      - user: {{ pillar['user'] }}
