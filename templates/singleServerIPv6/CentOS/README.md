# Single CentOS Server with IPv6

The following resources will be created by the template:

* A new network
* Two new subnets within the network
  * The first subnet is an IPv4 subnet with a hardcoded cidr: 10.100.0.0/16
  * The second subnet is an IPv6 subnet, dynamically generated from an existings subnet pool
  * The name or ID of the subnet pool can be updated in the centos_env.yml file
* A router with the new subnets assigned and internet connection
* A new security group with the following rules:
  * Ingress ICMP for IPv4 and IPv6 from any destination
  * Ingress SSH for IPv4 and IPv6 from any destination

## Requirements

* CentOS 7 (Should also work with RHEL)
* OpenStack Mitaka or later
* Update centos_env.yml with the correct values for your OpenStack environment

## Start your heat stack

`openstack stack create --wait -t centos_server_dualstack.yaml -e centos_env.yaml singleServerIPv6CentOS`

## Delete your heat stack

`openstack stack delete --wait singleServerIPv6CentOS`
