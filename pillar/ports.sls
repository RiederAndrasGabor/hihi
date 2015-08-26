rabbitmq_ports:

  - 
    port: 5672
    proto: tcp


libvirt_ports:

  - 
    range: 
      - 49152
      - 49215
    proto: tcp

  - 
    port: 16509
    proto: tcp


nfs_server_ports:

  - 
    port: 2049
    proto: tcp

  - 
    port: 2049
    proto: udp

  - 
    port: 111
    proto: tcp
  
  - 
    port: 111
    proto: udp

  - 
    port: 20048
    proto: tcp

  - 
    port: 20048
    proto: udp

  - 
    port: 33100
    proto: tcp

  - 
    port: 33100
    proto: udp

  - 
    port: 32803
    proto: tcp

  - 
    port: 32769
    proto: udp
