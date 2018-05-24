include:
  - network

/home/{{ pillar['user'] }}/.virtualenvs/vmdriver/bin/postactivate:
  file.managed:
    - source: salt://vmdriver/files/postactivate
    - template: jinja
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - mode: 700

{% set service_dir = "/etc/systemd/system/" if grains['os_family'] == 'RedHat' or grains['os'] == 'Debian' or grains['os'] == 'Ubuntu' and grains['oscodename'] == 'xenial' else "/etc/init/" %}
{% set service_files = (("vmcelery@.service", "netcelery@.service", "node.service")
                        if grains['os_family'] == 'RedHat' 
                        or grains['os'] == 'Debian'
                        or grains['os'] == 'Ubuntu' and grains['oscodename'] == 'xenial' else
                        ("vmcelery.conf", "netcelery.conf", "node.conf")) %}

{% for file in service_files %}
{{ service_dir ~ file }}:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - source: file:///home/{{ pillar['user'] }}/vmdriver/miscellaneous/{{ file }}
{% endfor %}

/etc/sudoers.d/netdriver:
  file.managed:
    - source: salt://vmdriver/files/sudoers
    - template: jinja
    - user: root
    - group: root
    - mode: 600
