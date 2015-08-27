rpcbind_for_nfs_client:
  pkg.installed:
    - name: rpcbind

  service:
   - running
   - name: rpcbind
   - reload: True
   - require:
     - pkg: rpcbind

nfs-client:
  pkg.installed:
    - pkgs:
      {% if grains['os_family'] == 'RedHat' %}
      - nfs-utils
      {% else %}
      - nfs-common
      {% endif %}
    - require_in:
      - mount: /datastore

{% if grains['os_family'] == 'RedHat' %}
nfs_selinux:
  pkg.installed:
    - pkgs:
      - policycoreutils
      - policycoreutils-python
  selinux.boolean:
    - name: virt_use_nfs
    - value: True
    - persist: True
    - require:
      - pkg: nfs-client
{% endif %}


/datastore:
  mount.mounted:
    - device: {{ pillar['nfs']['server'] }}:/datastore
    - fstype: nfs
    - opts: rw,nfsvers=3,noatime
    - dump: 0
    - pass_num: 2
    - persist: True
    - mkmnt: True
    - require:
      - service: rpcbind_for_nfs_client
      {% if grains['os_family'] == 'RedHat' %}
      - pkg: nfs_selinux
      {% endif %}

