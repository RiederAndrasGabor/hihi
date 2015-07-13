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

/datastore:
  mount.mounted:
    - device: {{ pillar['nfs']['server'] }}:/datastore
    - fstype: nfs
    - opts: rw,nfsvers=3,noatime
    - dump: 0
    - pass_num: 2
    - persist: True
    - mkmnt: True
