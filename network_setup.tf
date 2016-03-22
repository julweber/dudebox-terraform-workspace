# Creates a Network
resource "openstack_networking_network_v2" "dudenet" {
  name = "dudenet"
  admin_state_up = "true"
}

# Creates a subnet
resource "openstack_networking_subnet_v2" "dudenet_subnet1" {
  name = "dudenet_subnet1"
  network_id = "${openstack_networking_network_v2.dudenet.id}"
  cidr = "10.100.0.0/24"
  gateway_ip = "10.100.0.1"
  enable_dhcp = "true"
  dns_nameservers = ["${var.dns1}","${var.dns2}"]
  ip_version = 4
}

# Creates a router
resource "openstack_networking_router_v2" "dudenet_router" {
  region = "${var.os_region}"
  name = "dudenet_router"
  external_gateway = "${var.os_fip_network_uuid}"
}

# Router interface to the dudenet_subnet1
resource "openstack_networking_router_interface_v2" "dudenet_subnet1_router_interface" {
  region = "${var.os_region}"
  router_id = "${openstack_networking_router_v2.dudenet_router.id}"
  subnet_id = "${openstack_networking_subnet_v2.dudenet_subnet1.id}"
}
