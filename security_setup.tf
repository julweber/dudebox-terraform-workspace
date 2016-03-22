#Provide main private key to connect
resource "openstack_compute_keypair_v2" "dudebox_key"{
  name        = "dudebox_key"
  public_key  = "${file("${var.public_key_main}")}"
}

# Creates the ssh security group
resource "openstack_compute_secgroup_v2" "dudenet_ssh" {
  name = "dudenet_ssh"
  description = "opening port 22 for all connections"
  rule {
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
}

# Creates ping rule
resource "openstack_compute_secgroup_v2" "dudenet_ping" {
  name = "dudenet_ping"
  description = "allowing icmp connections"
  rule {
    from_port = -1
    to_port = -1
    ip_protocol = "icmp"
    cidr = "0.0.0.0/0"
  }
}
