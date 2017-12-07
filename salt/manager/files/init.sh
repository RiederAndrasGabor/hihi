#!/bin/bash

source /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/activate
source /home/{{ pillar['user'] }}/.virtualenvs/circle/bin/postactivate
{% set fw = pillar['fwdriver'] %}

HOSTNAME=$(hostname -s)

EXTRAPARAMS=""
if [ "{{ pillar['vmdriver']['hypervisor_type'] }}" = "kvm" ]; then
    EXTRAPARAMS="--kvm-present"
fi

exec python /home/{{ pillar['user'] }}/circle/circle/manage.py init \
    --external-net={{ fw['external_net'] }} \
    --management-net={{ fw['management_net'] }} \
    --vm-net={{ fw['vm_net'] }} \
    --admin-user={{ pillar['admin_user'] }} \
    --admin-pass={{ pillar['admin_pass'] }} \
    --datastore-queue={{ pillar['storagedriver']['queue_name'] }} \
    --firewall-queue={{ fw['queue_name'] }} \
    --external-if={{ fw['external_if'] }} \
    --management-if={{ fw['management_if'] }} \
    --vm-if={{ fw['vm_if'] }} \
    --node-hostname=$HOSTNAME \
    --node-mac="99:AA:BB:CC:DD:EE" \
    --node-ip="127.0.0.1" \
    --node-name=$HOSTNAME \
    $EXTRAPARAMS
