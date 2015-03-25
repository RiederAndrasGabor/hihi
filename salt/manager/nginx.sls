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
{% if grains['os_family'] == 'RedHat' %}
    - name: ./make-dummy-cert circle.pem
{% else %}
    - name: openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout circle.key -out circle.crt -subj '/CN=localhost/O=My Company Name LTD./C=US' && cat circle.key circle.crt > circle.pem && rm circle.key circle.crt; chmod 600 circle.pem
{% endif %}
    - cwd: /etc/ssl/certs/
    - creates: /etc/ssl/certs/circle.pem

{% if grains['os_family'] == 'RedHat' %}
nginx_selinux:
  pkg.installed:
    - pkgs:
      - policycoreutils
      - policycoreutils-python
  selinux.boolean:
    - name: httpd_can_network_connect
    - value: True
    - persist: True
    - require:
      - pkg: nginx_selinux
{% endif %}

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
