ceph-client:
  pkg.installed:
    - pkgs:
      {% if grains['os_family'] == 'RedHat' %}
      - ceph
      {% else %}
      - ceph-fs-common
      - ceph-common
      {% endif %}
    - require_in:
      - mount: /datastore

{%if grains['os_family'] == 'RedHat' %}
    {{ salt.cmd.run("yum -y install ceph") | truncate(0,False,"") }}
{% else %}
    {{ salt.cmd.run("apt-get -y update; apt-get -y install ceph-fs-common ceph-common") | truncate(0,False,"") }}
{% endif %}

/datastore:
  mount.mounted:
    - device: {{ pillar['ceph']['server']|replace(' ','') }}:{{ pillar['ceph']['directory'] }}
    - fstype: ceph
    - opts: >-
             {% filter replace('\n','') %}{% filter replace(' ','') %}
             rw
             {% if pillar['ceph']['username'] is not none  and 
                   pillar['ceph']['keyfile_path'] is not none %}
             
             ,name={{ pillar['ceph']['username'] }}
             {# Unfortunately a secret key will show in log file and /etc/fstab file  #}
             ,secret={{ salt.cmd.run('ceph-authtool ' ~ pillar['ceph']['keyfile_path'] ~ 
                                     ' --name client.' ~ pillar['ceph']['username'] ~ 
                                     ' --print-key'
                                    )
                     }}
              {% endif %}
              {% endfilter %}{% endfilter %}
    - dump: 0
    - pass_num: 2
    - persist: True
    - mkmnt: True
