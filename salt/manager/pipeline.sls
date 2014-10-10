nodejs-legacy:
  pkg.installed

npm:
  pkg.installed:
    - require:
      - pkg: nodejs-legacy

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
