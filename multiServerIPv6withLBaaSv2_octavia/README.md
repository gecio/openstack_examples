# Two servers with IPv4 and IPv6 behind a Octavia-LoadBalancer

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

* Ubuntu 18.04 (it won't work with Ubuntu 12.04 or 14.04)
* OpenStack Queens or later
* OpenStack Octavia LBaaS v2
* Update lb_env.yml with the correct values for your OpenStack environment

## Start your heat stack

`openstack stack create -t lb_with_worker_setup.yaml -e lb_env.yaml --wait ipv6-lbaas-octavia`

### Get IP Addresses

```
$ openstack stack show ipv6-lbaas-octavia
+-----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field                 | Value                                                                                                                                                              |
+-----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| id                    | 9e2e916b-d226-498f-b410-db4b4cae3b7f                                                                                                                               |
| stack_name            | ipv6-lbaas-octavia                                                                                                                                                 |
| description           | No description                                                                                                                                                     |
| creation_time         | 2019-06-26T17:18:17Z                                                                                                                                               |
| updated_time          | None                                                                                                                                                               |
| stack_status          | CREATE_COMPLETE                                                                                                                                                    |
| stack_status_reason   | Stack CREATE completed successfully                                                                                                                                |
| parameters            | OS::project_id: a896a600eb9942529cf556bbfee849bb                                                                                                                   |
|                       | OS::stack_id: 9e2e916b-d226-498f-b410-db4b4cae3b7f                                                                                                                 |
|                       | OS::stack_name: ipv6-lbaas-octavia                                                                                                                                 |
|                       | availability_zone: es1                                                                                                                                             |
|                       | ipv6_subnetpool: customer-ipv6                                                                                                                                     |
|                       | provider_network: provider                                                                                                                                         |
|                       | server_image: Ubuntu 18.04 Bionic Beaver - Latest                                                                                                                  |
|                       | ssh_key: ansible_service_key                                                                                                                                       |
|                       |                                                                                                                                                                    |
| outputs               | - description: FloatingIP of the IPv4 LoadBalancer                                                                                                                 |
|                       |   output_key: ipv4_lb_address                                                                                                                                      |
|                       |   output_value: 185.116.244.133                                                                                                                                    |
|                       | - description: IPv6 address of the LoadBalancer                                                                                                                    |
|                       |   output_key: ipv6_lb_address                                                                                                                                      |
|                       |   output_value: 2a00:c320:1002::1d                                                                                                                                 |
...

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
