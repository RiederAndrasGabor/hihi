#!/bin/bash

source /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/activate
source /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/postactivate
python /home/{{ pillar['user'] }}/circle/circle/manage.py reload_firewall --sync --timeout={{ pillar['fwdriver']['reload_firewall_timeout'] }}
