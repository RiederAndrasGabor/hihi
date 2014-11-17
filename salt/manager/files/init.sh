#!/bin/bash

source /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/activate
source /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/postactivate
{% set fw = pillar['fwdriver'] %}
exec python /home/{{ pillar['user'] }}/circle/circle/manage.py init \
    --portal-ip={{ fw['portal_ip'] }} \
    --external-net={{ fw['external_net'] }} \
    --management-net={{ fw['management_net'] }} \
    --vm-net={{ fw['vm_net'] }} \
    --admin-user={{ pillar['admin_user'] }} \
    --admin-pass={{ pillar['admin_pass'] }} \
    --datastore-queue={{ pillar['storagedriver']['queue_name'] }} \
    --firewall-queue={{ fw['queue_name'] }} \
    --external-if={{ fw['external_if'] }} \
    --management-if={{ fw['management_if'] }} \
    --trunk-if={{ fw['trunk_if'] }}
