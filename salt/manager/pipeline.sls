{% if grains['os'] == 'Ubuntu' or grains['os'] == 'Debian' %}
nodejs-legacy:
  pkg.installed
{% endif %}

npm:
  {% if grains['os'] == 'Ubuntu' or grains['os'] == 'Debian' %}
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
