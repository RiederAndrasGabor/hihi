user: cloud

proxy_secret: xooquageire7uX1
secret_key: Ga4aex3Eesohngo
timezone: Europe/Budapest

deployment_type: production

admin_user: admin
admin_pass: admin

database:
  name: circle
  user: circle
  password: hoGei6paiN0ieda

amqp:
  user: cloud
  password: password
  host: 127.0.0.1
  port: 5672
  vhost: circle

graphite:
  user: monitor
  password: monitor
  host: 127.0.0.1
  port: 5672
  vhost: monitor
  queue: monitor
  secret_key: ahf2aim7ahLeo8n

cache: pylibmc://127.0.0.1:11211/

nfs:
  enabled: true
  server: 127.0.0.1
  network: 127.0.0.0/8
  directory: /datastore

storagedriver:
  queue_name: ubuntu

fwdriver:
  queue_name: ubuntu
  gateway: 10.9.255.254
  external_net: 10.9.0.64/16
  external_if: ens3
  trunk_if: linkb
  management_if: ethy
