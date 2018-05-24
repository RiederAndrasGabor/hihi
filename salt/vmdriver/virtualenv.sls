virtualenv_vmdriver:
  virtualenv.managed:
    - name: /home/{{ pillar['user'] }}/.virtualenvs/vmdriver
    - requirements: /home/{{ pillar['user'] }}/vmdriver/requirements/production.txt
    - user: {{ pillar['user'] }}
    - no_chown: true

{% set libvirt_dir = "/usr/lib64/python2.7/site-packages/" if grains['os_family'] == 'RedHat' else "/usr/lib/python2.7/dist-packages/" %}

{% set targets = { 'libvirtmod_qemu.so': 'libvirtmod_qemu.x86_64-linux-gnu.so',
                   'libvirtmod.so': 'libvirtmod.x86_64-linux-gnu.so'
                 } if grains['os'] == 'Debian' or grains['os'] == 'Ubuntu' and grains['oscodename'] == 'xenial' else {} %}

{% for file in ("libvirtmod_qemu.so", "libvirtmod.so", "libvirt_qemu.py", "libvirt.py", "libvirt_qemu.pyc", "libvirt.pyc") %}
/home/{{ pillar['user'] }}/.virtualenvs/vmdriver/lib/python2.7/site-packages/{{ file }}:
  file.symlink:
    - target: {{ libvirt_dir + targets[file]|default(file) }}
    - require:
      - virtualenv: virtualenv_vmdriver
{% endfor %}
