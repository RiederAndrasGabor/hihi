#!/bin/bash 
source /home/{{ pillar['graphite']['user'] }}/.virtualenvs/graphite/bin/activate;
cd /opt/graphite/webapp/graphite/
python manage.py syncdb --noinput
