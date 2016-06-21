add_ceph_repokeys:
  cmd.run:
    {% if grains['os_family'] == 'RedHat' %}
    - name: rpm --import "{{ pillar['ceph']['repo_keys_url'] }}"
    {% else %}
    - name: wget -q -O- "{{ pillar['ceph']['repo_keys_url'] }}" | apt-key add -
    {% endif %}

add_ceph_repo:
  {% if grains['os_family'] == 'RedHat' %}
  file.managed:
    - name: /etc/yum.repos.d/ceph.repo
    - source: salt://ceph/files/repo_template
    - template: jinja
    - user: root
    - group: root
    - mode: 744
  {% else %}
  cmd.run:
    - name: deb {{ pillar['ceph']['repo_url'] }}/debian-{{ pillar['ceph']['release'] }}/ $(lsb_release -sc) main > /etc/apt/sources.list.d/ceph.list
  {% endif %}
    - require:
      - cmd: add_ceph_repokeys
