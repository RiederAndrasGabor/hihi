{% if grains['os'] == 'Debian' and grains['oscodename'] == 'stretch' %}
{# Debian 9 stretch has no npm. 
   Using nodesource repo where nodejs package provides npm. #}
nodesource-repo:
  pkgrepo.managed:
    - humanname: Nodesource Repository
    - name: deb http://deb.nodesource.com/node_6.x stretch main
    - dist: stretch
    - file: /etc/apt/sources.list.d/nodesource.list
#    - key_url: 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key'
    - keyid: '68576280'
    - keyserver: keys.gnupg.net
    - require-in:
      - pkg: npm
    - require:
      - pkg: python-apt

python-apt:
  pkg.installed
{% endif %}

{% if grains['os'] == 'Ubuntu' or ( grains['os'] == 'Debian' and grains['oscodename'] != 'stretch' ) %}
nodejs-legacy:
  pkg.installed
{% endif %}

npm:
  {% if grains['os'] == 'Debian' and grains['oscodename'] == 'stretch' %}
  {# nodesource nodejs package has executables node, nodejs, npm #}
  pkg.installed:
    - name: nodejs
  {% elif grains['os'] == 'Ubuntu' or grains['os'] == 'Debian' %}
  pkg.installed:
    - require:
      - pkg: nodejs-legacy
  {% else %}
  pkg.installed
  {% endif %}

bower:
  npm.installed:
    - require:
      - pkg: npm

less:
  npm.installed:
    - require:
      - pkg: npm

yuglify:
  npm.installed:
    - require:
      - pkg: npm
