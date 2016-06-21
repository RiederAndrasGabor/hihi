include:
  - ceph.configuration

ceph:
  pkg.installed:
    - pkgs:
      - ceph-common
      - ceph
    - require:
      {% if grains['os_family'] == 'RedHat' %}
      - file: add_ceph_repo
      {% else %}
      - cmd: add_ceph_repo
      {% endif %}
