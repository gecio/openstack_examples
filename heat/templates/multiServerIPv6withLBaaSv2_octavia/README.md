# Two servers with IPv4 and IPv6 behind an Octavia LoadBalancer

The following resources will be created by the template:

* A new network
* Two subnets within the network
  * The first subnet is an IPv4 subnet with a hardcoded cidr: 10.100.0.0/16
  * The second subnet is an IPv6 subnet, dynamically generated from an existing subnet pool
  * The name or ID of the subnet pool can be updated in the lb_env.yaml file
* A router with the new subnets assigned and internet connection
* A new security group with the following rules:
  * Ingress TCP/8000 for IPv4 and IPv6 from any destination
  * Ingress ICMP for IPv4 and IPv6 from any destination
  * Ingress SSH for IPv4 and IPv6 from any destination
* IPv4 LoadBalancer
* IPv6 LoadBalancer
* FloatingIP (IPv4) associated to the IPv4 LoadBalancer
* A ResourceGroup with ...
  * Two servers with two interfaces each (1. IPv4, 2. IPv6, to get the ordering for LoadBalancer Members right)
  * Each server runs [emilevauge/whoamI](https://github.com/emilevauge/whoamI) listening on port `8000`
  * LoadBalancer Member for each server on IPv4 LoadBalancer
  * LoadBalancer Member for each server on IPv6 LoadBalancer

## Requirements

* Ubuntu >=18.04
* OpenStack Queens or later
* OpenStack Octavia LBaaS v2
* Update lb_env.yml with the correct values for your OpenStack environment

## Start your heat stack

`openstack stack create -t lb_with_worker_setup.yaml -e lb_env.yaml --wait ipv6-lbaas-octavia`

### Get IP Addresses

```
$ openstack stack output show --all ipv6-lbaas-octavia
+-----------------+--------------------------------------------------------+
| Field           | Value                                                  |
+-----------------+--------------------------------------------------------+
| ipv4_lb_address | {                                                      |
|                 |   "output_value": "185.116.xxx.xxx",                   |
|                 |   "output_key": "ipv4_lb_address",                     |
|                 |   "description": "FloatingIP of the IPv4 LoadBalancer" |
|                 | }                                                      |
| ipv6_lb_address | {                                                      |
|                 |   "output_value": "2a00:xxxx:xxxx::XX",                |
|                 |   "output_key": "ipv6_lb_address",                     |
|                 |   "description": "IPv6 address of the LoadBalancer"    |
|                 | }                                                      |
+-----------------+--------------------------------------------------------+

```

After a few (5-10) minutes, the web applications should be reachable.
note: if the cloud-init-package_upgrade is set to true ~> +5 minutes

```
$ curl 185.116.244.133
Hostname: dualstack-ubuntu-worker-node0
IP: 127.0.0.1
IP: ::1
IP: 10.100.0.12
IP: fe80::f816:3eff:fe64:6c76
IP: 2a00:c320:1002::4
IP: fe80::f816:3eff:fed1:3a01
GET / HTTP/1.1
Host: 185.116.244.133
User-Agent: curl/7.54.0
Accept: */*

$ curl [2a00:c320:1002::1d]
Hostname: dualstack-ubuntu-worker-node0
IP: 127.0.0.1
IP: ::1
IP: 10.100.0.12
IP: fe80::f816:3eff:fe64:6c76
IP: 2a00:c320:1002::4
IP: fe80::f816:3eff:fed1:3a01
GET / HTTP/1.1
Host: [2a00:c320:1002::1d]
User-Agent: curl/7.54.0
Accept: */*

```

## Delete your heat stack

`openstack stack delete --wait ipv6-lbaas-octavia`
