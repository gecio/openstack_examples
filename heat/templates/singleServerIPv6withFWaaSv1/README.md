# Single Ubuntu Server with IPv6 and FWaaS v1

The following resources will be created by the template:

* A new network
* Two new subnets within the network
  * The first subnet is an IPv4 subnet with a hardcoded cidr: 10.100.0.0/16
  * The second subnet is an IPv6 subnet, dynamically generated from an existing subnet pool
  * The name or ID of the subnet pool can be updated in the ubuntu_env.yml file
* A router with the new subnets assigned and internet connection
* A new security group with the following rules:
  * Ingress ICMP for IPv4 and IPv6 from any destination
  * Ingress SSH for IPv4 and IPv6 from any destination
* A firewall ruleset to allow traffic from a specific IPv4 and IPv6 address to ssh
  * Addresses can be updated in the ubuntu_env.yml file

## Requirements

* Ubuntu 16.04 (it won't work with Ubuntu 12.04 or 14.04)
* OpenStack Mitaka or later
* Update ubuntu_env.yml with the correct values for your OpenStack environment
* OpenStack Neutron FWaaS v1

## Start your heat stack

`openstack stack create --wait -t ubuntu_server_dualstack.yaml -e ubuntu_env.yaml singleServerIPv6Ubuntu`

## Delete your heat stack

`openstack stack delete --wait singleServerIPv6Ubuntu`
