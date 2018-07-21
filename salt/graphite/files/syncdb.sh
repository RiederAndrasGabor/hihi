#!/bin/bash 
source /opt/graphite/bin/activate;
cd /opt/graphite/webapp/graphite/
PYTHONPATH="/opt/graphite/lib/:/opt/graphite/webapp/" django-admin.py migrate --settings=graphite.settings --noinput
