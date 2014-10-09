#!/bin/bash
sudo stop manager
sudo stop portal
source /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/activate
source /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/postactivate
python /home/{{ pillar['user'] }}/circle/circle/manage.py syncdb --all --noinput
python /home/{{ pillar['user'] }}/circle/circle/manage.py migrate acl
python /home/{{ pillar['user'] }}/circle/circle/manage.py migrate firewall
python /home/{{ pillar['user'] }}/circle/circle/manage.py migrate storage
python /home/{{ pillar['user'] }}/circle/circle/manage.py syncdb --migrate --noinput
python /home/{{ pillar['user'] }}/circle/circle/manage.py migrate vm --merge
