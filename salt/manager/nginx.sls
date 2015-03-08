nginx:
  service.running:
    - enable: True
    - require:
       - pkg: nginx
       - cmd: circlecert
       - file: nginxdefault
       {% if grains['os_family'] == 'RedHat' %}
       - file: nginxconf
       {% endif %}
  pkg:
   - installed

circlecert:
  cmd.run:
    - name: ./make-dummy-cert circle.pem
    - cwd: /etc/ssl/certs/
    - creates: /etc/ssl/certs/circle.pem

nginxdefault:
  file.managed:
  {% if grains['os_family'] == 'RedHat' %}
    - name: /etc/nginx/conf.d/default.conf
  {% else %}
    - name: /etc/nginx/sites-enabled/default
  {% endif %}
    - template: jinja
    - source: salt://manager/files/nginx-default-site.conf
    - user: root
    - group: root
    - require:
       - pkg: nginx

{% if grains['os_family'] == 'RedHat' %}
nginxconf:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - template: jinja
    - source: salt://manager/files/nginx.conf
    - user: root
    - group: root
    - require:
       - pkg: nginx
{% endif %}
