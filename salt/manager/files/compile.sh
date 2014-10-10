#!/bin/bash
cd /home/{{ pillar['user'] }}/circle/circle/
source /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/activate
source /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/postactivate
bower install
python /home/{{ pillar['user'] }}/circle/circle/manage.py collectstatic --noinput
python /home/{{ pillar['user'] }}/circle/circle/manage.py compilemessages
