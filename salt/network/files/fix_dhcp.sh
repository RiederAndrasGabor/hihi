#!/bin/bash
sed -i '/HWADDR=.*/d' /etc/sysconfig/network-scripts/ifcfg-vm
sed -i -e \$aNM_CONTROLLED=\"no\" /etc/sysconfig/network-scripts/ifcfg-vm
ifup vm
systemctl restart firewall
systemctl restart dhcpd

exit 0

