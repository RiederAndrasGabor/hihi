import salt.client
from salt import config
from salt.log.setup import setup_console_logger
from os.path import join, abspath, dirname
from netifaces import ifaddresses, gateways, AF_INET
from netaddr import IPNetwork
import socket
import yaml
import random
import os
import getpass
import argparse


PREFIX = dirname(__file__)


def get_timezone():
    localtime = '/etc/localtime'
    try:
        zonefile = abspath(os.readlink(localtime))
        zone_parts = zonefile.split('/')
        return join(zone_parts[-2], zone_parts[-1])
    except Exception:
        return 'Europe/Budapest'


def get_gateway():
    return gateways()['default'][AF_INET]


def get_default_gw():
    return get_gateway()[0]


def get_interface():
    return get_gateway()[1]


def get_ip_with_mask(intf):
    ip = ifaddresses(intf)[AF_INET][0]
    return str(IPNetwork(join(ip['addr'], ip['netmask'])))


def get_hostname():
    return str(socket.gethostname().split('.')[0])


def print_warning(text):
    RED_UNDERLINED = '\033[4;31m'
    NC = '\033[0m'  # No Color
    print(RED_UNDERLINED + text + NC)


def input_password_with_retype():
    pw = getpass.getpass("Enter admin password:")
    if len(pw) == 0:
        print_warning('Please enter a non-empty password!')
        return ('', False)
    pw2 = getpass.getpass("Retype password:")
    status = pw == pw2
    if not status:
        print_warning('The passwords are different.')
    return (pw, status)


def input_admin_password():
    pw, status = input_password_with_retype()
    while not status:
        pw, status = input_password_with_retype()
    return pw.encode('utf8')


def yaml_pretty_dump(data, file, **extra):
    yaml.dump(data, file, encoding='utf-8', default_flow_style=False, **extra)


def dump_errors(result):
    # Filter errors only
    errors = {}
    for key, data in result.iteritems():
        if not data['result']:
            errors[key] = data
    with open(join(PREFIX, 'errors.yml'), 'w') as f:
        yaml_pretty_dump(errors, f)


class KeyStore:
    """ Loads, stores, generates, and saves secret keys """
    def __init__(self, keyfile):
        self.keyfile = keyfile
        self.data = {}
        try:
            with open(keyfile) as f:
                self.data = yaml.safe_load(f)
        except Exception:
            pass

    def gen_key(self, length):
        s = "abcdefghijklmnopqrstuvwxyz01234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return "".join(random.sample(s, length))

    def get_key(self, name):
        key = self.data.get(name)
        if key is None:
            key = self.gen_key(16)
            self.data[name] = key
        return key

    def save(self):
        with open(self.keyfile, 'w') as f:
            yaml.dump(self.data, f)


parser = argparse.ArgumentParser()
parser.add_argument('--kvm-present', action='store_true',
                    help='Installs with KVM hypervisor otherwise with QEMU.')
args = parser.parse_args()

KEYFILE = join(PREFIX, '.circlekeys')
ks = KeyStore(KEYFILE)

installer_sls = {
    'user': 'cloud',
    'proxy_secret': ks.get_key('proxy_secret'),
    'secret_key': ks.get_key('secret_key'),
    'timezone': get_timezone(),
    'deployment_type': 'production',
    'admin_user': 'admin',
    'admin_pass': input_admin_password(),
    'database': {
        'name': 'circle',
        'user': 'circle',
        'password': ks.get_key('database_password'),
    },
    'amqp': {
        'user': 'cloud',
        'password': ks.get_key('amqp_password'),
        'host': '127.0.0.1',
        'port': 5672,
        'vhost': 'circle',
    },
    'graphite': {
        'user': 'monitor',
        'password': ks.get_key('graphite_password'),
        'host': '127.0.0.1',
        'port': 5672,
        'vhost': 'monitor',
        'queue': 'monitor',
        'secret_key': ks.get_key('graphite_secret_key'),
    },
    'cache': 'pylibmc://127.0.0.1:11211/',
    'nfs': {
        'enabled': True,
        'server': '127.0.0.1',
        'network': '127.0.0.0/8',
        'directory': '/datastore',
    },
    'storagedriver': {
        'queue_name': get_hostname(),
    },
    'fwdriver': {
        'gateway': get_default_gw().encode('utf-8'),
        'external_if': get_interface().encode('utf-8'),
        'external_net':  get_ip_with_mask(get_interface()).encode('utf-8'),
        'queue_name':  get_hostname(),
        'management_if': 'ethy',
        'trunk_if': 'linkb',
    },
    'vmdriver': {
        'hypervisor_type': 'kvm' if args.kvm_present else 'qemu',
    },
}

ks.save()  # Save secret keys

# Make installer.sls
INSTALLERT_SLS = join(PREFIX, 'pillar/installer.sls')
with open(INSTALLERT_SLS, 'w') as f:
    yaml_pretty_dump(installer_sls, f)

# NOTE: default logfile is '/var/log/salt/minion'
opts = config.minion_config('')
opts['file_client'] = 'local'
# NOTE: False will cause salt to only display output
#       for states that failed or states that have changes
opts['state_verbose'] = False
opts['file_roots'] = {'base': [join(PREFIX, 'salt')]}
opts['pillar_roots'] = {'base': [join(PREFIX, 'pillar')]}
setup_console_logger(log_level='info')
caller = salt.client.Caller(mopts=opts)

# Run install with salt
result = caller.function('state.sls', 'allinone', with_grains=True)

# Count errors and print to console
error_num = 0
for key, data in result.iteritems():
    if not data['result']:
        print('Error in state: %s' % key)
        error_num += 1

if error_num == 0:
    print('Succesfully installed!')
else:
    print_warning('%i error occured during install!' % error_num)
    dump_errors(result)

