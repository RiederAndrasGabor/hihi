manager_postactivate:
  file.managed:
      - name: /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/postactivate
      - source: salt://manager/files/postactivate
      - template: jinja
      - user: {{ pillar['user'] }}
      - mode: 700

portal.conf:
  file.managed:
    {% if grains['os_family'] == 'RedHat' or grains['os'] == 'Debian' %}
    - name: /etc/systemd/system/portal.service
    {% else %}
    - name: /etc/init/portal.conf
    {% endif %}
    - user: root
    - group: root
    - template: jinja
    {% if grains['os_family'] == 'RedHat' or grains['os'] == 'Debian' %}

    {% if pillar['deployment_type'] == 'production' %}
    - source: file:///home/{{ pillar['user'] }}/circle/miscellaneous/portal-uwsgi.service
    {% else %}
    - source: file:///home/{{ pillar['user'] }}/circle/miscellaneous/portal.service
    {% endif %}
    
    {% else %}
    
    {% if pillar['deployment_type'] == 'production' %}
    - source: file:///home/{{ pillar['user'] }}/circle/miscellaneous/portal-uwsgi.conf
    {% else %}
    - source: file:///home/{{ pillar['user'] }}/circle/miscellaneous/portal.conf
    {% endif %}

    {% endif %}

{% if grains['os_family'] == 'RedHat' or grains['os'] == 'Debian' %}
/etc/systemd/system/manager.service:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/circle/miscellaneous/manager.service

/etc/systemd/system/managercelery@.service:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/circle/miscellaneous/managercelery@.service

{% else %}

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
{% endif %}

salt://manager/files/init.sh:
  cmd.script:
    - template: jinja
    - user: {{ pillar['user'] }}
    - stateful: true
    - require:
      - virtualenv: virtualenv_manager
      - file: /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/postactivate
      - user: {{ pillar['user'] }}
