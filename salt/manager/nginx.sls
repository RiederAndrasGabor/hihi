nginx:
  pkg:
   - installed

  pkgrepo.managed:
    - ppa: nginx/stable
    - require_in:
      - pkg: nginx

  file.managed:
    - name: /etc/nginx/conf.d/default.conf
    - template: jinja
    - source: salt://manager/files/nginx.conf
    - user: root
    - group: root
    - require:
       - pkg: nginx
