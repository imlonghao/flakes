#!/usr/bin/env python

import json
import subprocess

nodes = {}
mapping = {}
current_node = ''

with open('/persist/ranet-registry.json', 'r') as f:
    j = json.loads(f.read())
    for node in j[0]['nodes']:
        nodes[f'100.64.0.{node["remarks"]["id"]}/32'] = node['common_name']

for line in subprocess.check_output(['swanctl', '--list-sas']).split(b'\n'):
    if b'remote' in line and b'CN=' in line:
        current_node = line.split(b'CN=')[1].split(b',')[0]
        continue
    if b'out' in line and b'0x' in line:
        interface = line.split(b'(-|0x')[1].split(b')')[0]
        mapping[f'swan{interface.decode()}'] = current_node.decode()

def metrics(x):
    return float(x.split(' ')[3])

routes = [x for x in subprocess.check_output(['birdc', 'show', 'babel', 'routes']).decode().split('\n') if '*' in x]
routes = [' '.join(x.split()) for x in routes]
routes.sort(key=metrics)

for line in routes:
    r = line.split()
    for idx in range(len(r)):
        if mapping.get(r[idx]) != None:
            if nodes[r[0]] == mapping.get(r[idx]):
                print("{:15} {:25} {:10} {:25} {:10} {:5}".format(r[0], nodes[r[0]], 'direct', '', 'metrics', r[idx+1]))
            else:
                print("{:15} {:25} {:10} {:25} {:10} {:5}".format(r[0], nodes[r[0]], 'via', mapping.get(r[idx]), 'metrics', r[idx+1]))
