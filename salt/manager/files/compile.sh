#!/bin/bash
cd /home/{{ pillar['user'] }}/circle/circle/
source /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/activate
source /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/postactivate
MANAGE="python /home/{{ pillar['user'] }}/circle/circle/manage.py"
bower install

$MANAGE compileless
$MANAGE compilejsi18n -o dashboard/static/jsi18n

COLLECTED=$($MANAGE collectstatic --noinput |
            awk '/static files copied to/ {print $1}')

OLD_SHA=$(sha1sum locale/hu/LC_MESSAGES/*.mo)
$MANAGE compilemessages
NEW_SHA=$(sha1sum locale/hu/LC_MESSAGES/*.mo)

echo "$COLLECTED $NEW_SHA $OLD_SHA"
if [ "$NEW_SHA" != "$OLD_SHA" -o "$COLLECTED" -ne 0 ]; then
    CHANGED=yes
else
    CHANGED=no
fi

echo "changed=$CHANGED comment='copied: $COLLECTED'"
