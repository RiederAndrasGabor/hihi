{% if grains['os'] == 'Ubuntu' %}
nodejs-legacy:
  pkg.installed
{% endif %}

npm:
  {% if grains['os'] == 'Ubuntu' %}
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
