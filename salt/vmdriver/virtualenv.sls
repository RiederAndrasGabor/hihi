virtualenv_vmdriver:
  virtualenv.managed:
    - name: /home/{{ pillar['user'] }}/.virtualenvs/vmdriver
    - requirements: /home/{{ pillar['user'] }}/vmdriver/requirements/production.txt
    - runas: {{ pillar['user'] }}
    - no_chown: true

/home/{{ pillar['user'] }}/.virtualenvs/vmdriver/lib/python2.7/site-packages//libvirtmod_qemu.so:
  file.symlink:
    - target: /usr/lib/python2.7/dist-packages/libvirtmod_qemu.so
    - require:
      - virtualenv: virtualenv_vmdriver

/home/{{ pillar['user'] }}/.virtualenvs/vmdriver/lib/python2.7/site-packages//libvirtmod.so:
  file.symlink:
    - target: /usr/lib/python2.7/dist-packages/libvirtmod.so
    - require:
      - virtualenv: virtualenv_vmdriver

/home/{{ pillar['user'] }}/.virtualenvs/vmdriver/lib/python2.7/site-packages/libvirt_qemu.py:
  file.symlink:
    - target: /usr/lib/python2.7/dist-packages/libvirt_qemu.py
    - require:
      - virtualenv: virtualenv_vmdriver

/home/{{ pillar['user'] }}/.virtualenvs/vmdriver/lib/python2.7/site-packages/libvirt.py:
  file.symlink:
    - target: /usr/lib/python2.7/dist-packages/libvirt.py
    - require:
      - virtualenv: virtualenv_vmdriver

/home/{{ pillar['user'] }}/.virtualenvs/vmdriver/lib/python2.7/site-packages/libvirt_qemu.pyc:
  file.symlink:
    - target: /usr/lib/python2.7/dist-packages/libvirt_qemu.pyc
    - require:
      - virtualenv: virtualenv_vmdriver

/home/{{ pillar['user'] }}/.virtualenvs/vmdriver/lib/python2.7/site-packages/libvirt.pyc:
  file.symlink:
    - target: /usr/lib/python2.7/dist-packages/libvirt.pyc
    - require:
      - virtualenv: virtualenv_vmdriver
