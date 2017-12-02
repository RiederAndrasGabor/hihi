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

npm_packages:
  npm.installed:
    - pkgs:
      - bower
      - less
      - yuglify
      - babel-cli
    - require:
      - pkg: npm

babel-preset-env:
  npm.installed:
    - user: {{ pillar['user'] }}
    - dir: /home/{{ pillar['user'] }}/circle/circle
    - require:
      - pkg: npm
