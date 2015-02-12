
## Git backend tutorial

### 1. Install salt master and register minion

```bash
sudo apt-get install salt-minion
sudo apt-get install salt-master
```

#### Edit /etc/salt/minion to set master to 127.0.0.1
#### Open 4505 and 4506 with ufw allow.
#### Restart master and minion. Accept minion key with salt-key -A.
#### Use -l debug option to show debug messages.

### 2. Install pygit2

#### 2.1 Without adding the repo, installing pygit is a bit difficult. Use this:

```bash
sudo add-apt-repository ppa:dennis/python
sudo apt-get update
sudo apt-get install python-pygit2
```

#### 2.2 Copy keys.

### 3. Modify the *master* config file:

```yaml
fileserver_backend:
  - git

gitfs_remotes:
  - git@git.ik.bme.hu:circle/salt.git:
    - pubkey: /root/.ssh/git.pub
    - privkey: /root/.ssh/git

pillar_roots:
  base:
    - /home/cloud/salt/pillar

gitfs_root: salt 
```

### 4. Clone pillar to /home/cloud/
```bash
git clone `https://git.ik.bme.hu/circle/salt.git
```

### 5. Finish: call salt '*' state.sls allinone (or whatever you need)

###  the *master* config file:

#### The default git provider is pygit2. You can change that to dulwich ot gitpython.

```yaml
gitfs_provider: dulwich
```

#### Include git in the fileserver_backend list:

```yaml
fileserver_backend:
  - git
```

#### Specify one or more git://, https://, file://, or ssh:// URLs in gitfs_remotes to configure which repositories to cache and search for requested files:

```yaml
gitfs_remotes:
  - git@git.ik.bme.hu:circle/salt.git
```

> The gitfs_remotes option accepts an ordered list of git remotes to cache and search, in listed order, for requested files.

#### Serving from subdirectory

```yaml
gitfs_root: foo/baz
```

#### Other options

Its possible to change branches, enviroments

Change branch:

```yaml
gitfs_base: salt-base
```


### Tutorial with more information:
http://docs.saltstack.com/en/latest/topics/tutorials/gitfs.html

### Local gitfs issue:
https://github.com/saltstack/salt/issues/6660
