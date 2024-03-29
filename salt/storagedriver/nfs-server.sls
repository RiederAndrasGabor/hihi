{% if pillar['nfs']['enabled'] %}
rpcbind:
  pkg:
   - installed

  service:
   - running
   - require:
     - pkg: rpcbind

nfs-server:
  service:
    {% if grains['os_family'] != 'RedHat' %}
    - name: nfs-kernel-server
    {% endif %}
    - running
    - watch:
      - file: /etc/exports
    - require:
      - service: rpcbind
  pkg.installed:
    {% if grains['os_family'] == 'RedHat' %}
    - name: nfs-utils
    {% else %}  
    - name: nfs-kernel-server
    {% endif %}

/etc/exports:
  file.managed:
    - template: jinja
    - sources:
      - salt://storagedriver/files/exports.tmpl
    - require:
      - pkg: nfs-server
{% endif %}
