#!/bin/bash

sudo stop manager >/dev/null 2>&1 
sudo stop portal >/dev/null 2>&1 
source /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/activate >/dev/null 2>&1 
source /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/postactivate >/dev/null 2>&1 
MANAGE="python /home/{{ pillar['user'] }}/circle/circle/manage.py"

OUT=$( ($MANAGE syncdb --noinput &&
        $MANAGE migrate acl &&
        $MANAGE migrate firewall &&
        $MANAGE migrate storage &&
        $MANAGE syncdb --migrate --noinput &&
        $MANAGE migrate vm --merge) 2>&1)

if [ $? -ne 0 ]; then
    /usr/bin/python -c "import sys; import json; sys.stdout.write(json.dumps({'changed': False, 'comment': sys.stdin.read()}) + '\n')" <<< "$OUT"
    exit 1
fi

COUNT=$(/bin/egrep "Migrating forwards to" -c <<< "$OUT")
if [ $? -eq 0 ]; then
    CHANGED=yes
else
    CHANGED=no
fi

echo "changed=$CHANGED comment='Migrated: $COUNT'"
