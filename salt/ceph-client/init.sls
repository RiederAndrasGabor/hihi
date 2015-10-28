ceph-client:
  pkg.installed:
    - pkgs:
      {% if grains['os_family'] == 'RedHat' %}
      - ceph
      {% else %}
      - ceph-fs-common
      {% endif %}
    - require_in:
      - mount: /datastore

/datastore:
  mount.mounted:
    - device: {{ pillar['ceph']['server'] }}:{{ pillar['ceph']['directory'] }}
    - fstype: ceph
    - opts: rw
    - dump: 0
    - pass_num: 2
    - persist: True
    - mkmnt: True
