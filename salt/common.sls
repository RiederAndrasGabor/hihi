git:
  pkg.installed
{% if grains['osfinger'] == 'Ubuntu-16.04' %}
ubuntu_virtualenvwrapper:
  file.append:
    - name: /etc/profile
    - text:
      - "export WORKON_HOME=$HOME/.virtualenvs"
      - "source /usr/share/virtualenvwrapper/virtualenvwrapper.sh"
{% endif %}