#!/bin/bash 
source /home/{{ pillar['graphite']['user'] }}/.virtualenvs/graphite/bin/activate;
cd /opt/graphite/webapp/graphite/
PYTHONPATH=/opt/graphite/webapp django-admin.py syncdb --settings=graphite.settings --noinput
