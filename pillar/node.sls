user: cloud

amqp:
  user: cloud
  password: password
  host: 192.168.120.1
  port: 5672
  vhost: circle

graphite:
  user: monitor
  password: monitor
  host: 192.168.120.1
  port: 5672
  vhost: monitor
  queue: monitor

cache: pylibmc://192.168.120.1:11211/

nfs:
  server: 192.168.120.1
  directory: /datastore
