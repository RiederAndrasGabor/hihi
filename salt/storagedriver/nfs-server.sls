{% if pillar['nfs']['enabled'] %}
nfs-server:
  service:
   - name: nfs-kernel-server
   - running
   - watch:
     - file: /etc/exports
  pkg.installed:
    - name: nfs-kernel-server
    
/etc/exports:
  file.managed:
    - template: jinja
    - sources:
      - salt://storagedriver/files/exports.tmpl
    - require:
      - pkg: nfs-server
{% endif %}
