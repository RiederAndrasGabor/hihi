#!/bin/bash
sed -i '/HWADDR=.*/d' /etc/sysconfig/network-scripts/ifcfg-vm
ifup vm
systemctl restart dhcpd

exit 0

