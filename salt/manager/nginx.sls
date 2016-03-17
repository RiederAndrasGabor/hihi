nginx:
  service.running:
    - enable: True
    - require:
       - pkg: nginx
       - cmd: circlecert
       - file: nginxdefault
       - file: nginx_home_permission
       {% if grains['os_family'] == 'RedHat' %}
       - file: nginxconf
       - cmd: nginx_no_private_temp
       {% endif %}
  pkg:
   - installed

nginx_home_permission:
  file.directory:
    - name: /home/{{ pillar['user'] }}
    - user: {{ pillar['user'] }}
    - dir_mode: 711

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
nginx_selinux_pkgs:
  pkg.installed:
    - pkgs:
      - policycoreutils
      - policycoreutils-python

nginx_httpd_can_network_connect:
  selinux.boolean:
    - name: httpd_can_network_connect
    - value: True
    - persist: True
    - require:
      - pkg: nginx_selinux_pkgs

nginx_httpd_read_user_content:
  selinux.boolean:
    - name: httpd_read_user_content
    - value: True
    - persist: True
    - require:
      - pkg: nginx_selinux_pkgs

/root/nginx.te:
  file.managed:
    - source: salt://manager/files/nginx.te
    - template: jinja
    - mode: 644

nginx_semodule:
  cmd.run:
    - cwd: /root
    - user: root
    - name: checkmodule -M -m -o nginx.mod nginx.te; semodule_package -o nginx.pp -m nginx.mod; semodule -i nginx.pp
    - unless: semodule -l |grep -qs ^nginx
    - require:
      - file: /root/nginx.te
      - pkg: nginx_selinux_pkgs

nginx_no_private_temp:
  cmd.run:
    - user: root
    - name: sed -i "/PrivateTmp/d" /usr/lib/systemd/system/nginx.service
    - require:
      - pkg: nginx
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
