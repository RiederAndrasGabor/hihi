fwdriver:
  repo_name: https://git.ik.bme.hu/circle/fwdriver.git
  repo_revision: master

  user: fw

  queue_name: cloud

  vm_if: vm
  vm_net: 192.168.2.254/24

  management_if: eth5
  management_net: 192.168.1.254/24

  external_if: eth0
  external_net: 10.0.0.97/16
  gateway: 10.0.255.254
