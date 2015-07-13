# Circle Project for Cent OS 7 - Salt Installer

## Install Salt

```bash
sudo add-apt-repository ppa:saltstack/salt
sudo apt-get update
sudo apt-get install salt-minion
```

## Configure salt
Open the salt minion configuration

```bash
sudo vim /etc/salt/minion
```

Add these lines:

```bash
file_client: local

file_roots:
  base:
    - /home/cloud/salt/salt

pillar_roots:
  base:
    - /home/cloud/salt/pillar
```
## Get the installer
Clone circle installer git repository into cloud home

```bash
git clone https://git.ik.bme.hu/circle/salt.git
```

## Change variables
Modify installer.sls file

```
sudo vim salt/pillar/installer.sls
```

Most used variables
-------------------
* user: user who will install the software
* proxy_secret: proxy secret key TODO
* secret_key: secret key TODO
* time zone: the server's time zone, format is region/city
* deployment_type: local or ? TODO
* **admin_user**: user name to login in as admin on the site
* **admin_pass**: password to login in as admin on the site
* database:
   * name: django database's name
   * user: database user
   * password: database user's password
* amqp:
   * user: amqp user
   * password: ampq user's password
   * host: amqp server IP - usually runs at localhost
   * port: amqp server's port
   * vhost: virtual host - specifies the namespace for entities (exchanges and queues) referred to by the protocol
* graphite:
   * user: graphite user
   * password: graphite user's password
   * host: graphite server IP - usually runs at localhost
   * port: graphite server's port
   * vhost: TODO
   * queue: TODO
   * secret_key: graphite's secret key
* cache: cache url - usually pylibmc://127.0.0.1:11211/
* nfs:
   * enabled: nfs is enabled
   * server: nfs server's hostname
   * network: nfs server's network to access files
   * directory: this directory will be shared
* storagedriver:
   * queue_name: TODO
* fwdriver:
   * queue_name: the server's hostname
   * gateway: the server's gateway
   * EXTERNAL_Net: the server's network
   * external_if: the server's network interface
   * trunk_if: trunk interface TODO
   * management_if: TODO

Other variables
---------------
* agent:
   * repo_name: the agent repository's name
   * repo_revision: revision
* agentdriver:
   * repo_name: the agentdriver repository's name
   * repo_revision: revision
* fwdriver:
   * repo_name: the fwdriver repository's name
   * repo_revision: revision
   * user: fwdriver user name
   * vm_if: vm interface
   * vm_et: vm network
* manager:
   * repo_name: the manager repository's name
   * repo_revision: revision
* monitor-client:
   * repo_name: the monitor-client repository's name
   * repo_revision: revision
* storage-driver:
   * repo_name: the storage-driver repository's name
   * repo_revision: revision
* vm-driver:
   * repo_name: the vm-driver repository's name
   * repo_revision: revision
* vnc-driver:
   * repo_name: the vnc-driver repository's name
   * repo_revision: revision

## Install Circle
Run the following installation command:

```bash
sudo salt-call state.sls allinone
```

After install, delete agent.conf file:

```bash
sudo rm /etc/init/agent.conf
```

## Quickstart - Standalone Node

### Login
Log in into the Circle website with admin (the site is accessable on the 443 port). Name and password is in the `salt/pillar/installer.sls`.

### Create Node
To run virtual machines, we need to create nodes - and add to the system. Click on the new icon in the dashboard, Nodes menu.

#### Configure Node

To standalone configuration, type the current machine's hostname to Host/name, MAC address to Host/MAC, IP to HOST/IP. Choose managed-vm as VLAN.

#### Activate Node

Click on the 'Activate' icon to use the Node.

### Start Virtual Machine

To create new Virtual Machine, we use Templates - images based on previously saved VMs. Currently we haven't got any template - so let's create a new one. Click on Templates/new icon and choose 'Create a new base VM without disk'.

#### Configure Template

Set name, CPU and RAM settings, architecture. Check in the boot menu box, select network and lease, write down, which operating system will you use. Finally, create a template.
> The rows marked with astersk need to be filled.

![configure standalone node](_static/images/configure_node.jpg)

#### Add disk

Currently we don't have any disks attached to our VM. To add, click on the Resources menu, 'create disk' icon, set the name and size.

![disk setup](_static/images/disk.jpg)

#### Attach ISO

To install an OS, we can use ISO images, to boot from. Click on 'download disk' and type the ISO's URL.

![download iso](_static/images/iso.jpg)

### Start Virtual Machine
Finally, we can run the machine. Click on 'deploy' and start it. You can choose, on which node do you want to run.

![ubuntu 14.04](_static/images/ubuntu.png)