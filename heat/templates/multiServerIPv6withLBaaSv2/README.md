# Two servers with IPv4 and IPv6 behind a LoadBalancer

The following resources will be created by the template:

* A new network
* Two subnets within the network
  * The first subnet is an IPv4 subnet with a hardcoded cidr: 10.100.0.0/16
  * The second subnet is an IPv6 subnet, dynamically generated from an existing subnet pool
  * The name or ID of the subnet pool can be updated in the ubuntu_env.yml file
* A router with the new subnets assigned and internet connection
* A new security group with the following rules:
  * Ingress ICMP for IPv4 and IPv6 from any destination
  * Ingress SSH for IPv4 and IPv6 from any destination
* IPv4 LoadBalancer
* IPv6 LoadBalancer
* FloatingIP (IPv4) associated to the IPv4 LoadBalancer
* A ResourceGroup with ...
  * `count` servers with two interfaces each (1. IPv4, 2. IPv6, to get the ordering for LoadBalancer Members right)
  * Each server runs [emilevauge/whoamI](https://github.com/emilevauge/whoamI) listening on port `8000`
  * LoadBalancer Member for each server on IPv4 LoadBalancer
  * LoadBalancer Member for each server on IPv6 LoadBalancer

## Requirements

* Ubuntu 16.04 (it won't work with Ubuntu 12.04 or 14.04)
* OpenStack Mitaka or later
* OpenStack Neutron LBaaS v2
* Update lb_env.yml with the correct values for your OpenStack environment

## Start your heat stack

`openstack stack create -t lb_with_worker_setup.yaml -e lb_env.yaml --wait ipv6-lbaas`

### Get IP Addresses

```
$ openstack stack show ipv6-lbaas

+-----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| Field                 | Value                                                                                                                                             |
+-----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------+
| id                    | a9b9480c-80bc-4f67-8025-f393c60a5be2                                                                                                              |
| stack_name            | ipv6-lbaas                                                                                                                                        |
| description           | No description                                                                                                                                    |
| creation_time         | 2017-11-03T17:36:04Z                                                                                                                              |
| updated_time          | None                                                                                                                                              |
| stack_status          | CREATE_COMPLETE                                                                                                                                   |
| stack_status_reason   | Stack CREATE completed successfully                                                                                                               |
| parameters            | OS::project_id: af8e5f9815c54afea53962fd4a13c745                                                                                                  |
|                       | OS::stack_id: a9b9480c-80bc-4f67-8025-f393c60a5be2                                                                                                |
|                       | OS::stack_name: ipv6-lbaas                                                                                                                        |
|                       | ipv6_subnetpool: customer-ipv6                                                                                                                    |
|                       | provider_network: provider                                                                                                                        |
|                       | server_image: Ubuntu 16.04 Xenial Xerus - Latest                                                                                                  |
|                       | ssh_key: cg                                                                                                                                       |
|                       |                                                                                                                                                   |
| outputs               | - description: FloatingIP of the IPv4 LoadBalancer                                                                                                |
|                       |   output_key: ipv4_lb_address                                                                                                                     |
|                       |   output_value: 185.116.245.60                                                                                                                    |
|                       | - description: IPv6 address of the LoadBalancer                                                                                                   |
|                       |   output_key: ipv6_lb_address                                                                                                                     |
|                       |   output_value: 2a00:c320:1000:3::2                                                                                                               |
|                       |                                                                                                                                                   |
| [...]                                                                                                                                                                     |
+-----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------+
```

After a few minutes, the web applications should be reachable

```
$ curl [2a00:c320:1000:3::2]
Hostname: dualstack-ubuntu-worker-node1
IP: 127.0.0.1
IP: ::1
IP: 10.100.0.11
IP: fe80::f816:3eff:fecf:5eb8
IP: 2a00:c320:1000:3::7
IP: fe80::f816:3eff:fe50:c628
GET / HTTP/1.1
Host: [2a00:c320:1000:3::2]
User-Agent: curl/7.54.0
Accept: */*
X-Forwarded-For: 2003:84:af1b:bf00:f4e8:3201:1bdb:8884

$ curl 185.116.245.60
Hostname: dualstack-ubuntu-worker-node1
IP: 127.0.0.1
IP: ::1
IP: 10.100.0.11
IP: fe80::f816:3eff:fecf:5eb8
IP: 2a00:c320:1000:3::7
IP: fe80::f816:3eff:fe50:c628
GET / HTTP/1.1
Host: 185.116.245.60
User-Agent: curl/7.54.0
Accept: */*
X-Forwarded-For: 79.228.235.172
```

## Delete your heat stack

`openstack stack delete --wait ipv6-lbaas`
