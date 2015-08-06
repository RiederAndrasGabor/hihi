#!/bin/bash

# Opens nfs ports

{% if grains['os_family'] == 'RedHat' %}
firewall-cmd --complete-reload

# NFS
firewall-cmd --permanent --zone=public --add-port=2049/tcp
firewall-cmd --permanent --zone=public --add-port=2049/udp

# rpcbind/sunrpc
firewall-cmd --permanent --zone=public --add-port=111/tcp
firewall-cmd --permanent --zone=public --add-port=111/udp

# MOUNTD_PORT
firewall-cmd --permanent --zone=public --add-port=20048/tcp
firewall-cmd --permanent --zone=public --add-port=20048/udp

# STATD_PORT
firewall-cmd --permanent --zone=public --add-port=33100/tcp
firewall-cmd --permanent --zone=public --add-port=33100/udp

# LOCKD_TCPPORT
firewall-cmd --permanent --zone=public --add-port=32803/tcp

# LOCKD_UDPPORT
firewall-cmd --permanent --zone=public --add-port=32769/udp

firewall-cmd --reload
{% else %}
# NFS
ufw allow 2049

# rpcbind/sunrpc
ufw allow 111

# MOUNTD_PORT
uf allow 20048

# STATD_PORT
ufw allow 33100

# LOCKD_TCPPORT
ufw allow 32803/tcp

# LOCKD_UDPPORT
ufw allow 32769/udp
{% endif %}
