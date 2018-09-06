#cloud-config
apt:
  sources:
    ceph-${ceph_version}.list:
      source: "deb https://download.ceph.com/debian-${ceph_version}/ bionic main"
      keyid: 460F3994
package_update: true
package_upgrade: true
packages:
  - ceph-common
ssh_authorized_keys:
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDlXDyf+MnSS3HDxX7lzfXlpWlbpkOKpw2uVcVlU6lqgQZKtxfTcCjZG/UBJBQNp7QxQPEce key1@host
  - ssh-rsa sO7IYeBWJh0/JYGRQNDLAwLrdsoDPxiytyR6Yh31yFvz+vyhIOEo6eve5CMgfpqny2OxhoaTsO7IYeBWJh0/JYGRQNDLAwLrdsoDP key2@host
