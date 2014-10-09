#!/bin/bash
source /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/activate
source /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/postactivate
python /home/{{ pillar['user'] }}/circle/circle/manage.py collectstatic --noinput
python /home/{{ pillar['user'] }}/circle/circle/manage.py compilemessages
