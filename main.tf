# Creates a Floating IP
resource "openstack_compute_floatingip_v2" "dudebox_fip"{
  pool = "${var.os_fip_network_name}"
}

#Creates the VM
resource "openstack_compute_instance_v2" "dudebox" {
  name            = "dudebox"
  image_name      = "${var.image_name}"
  flavor_name     = "${var.flavor_name}"
  security_groups = ["dudenet_ssh", "dudenet_ping"]
  key_pair        = "${openstack_compute_keypair_v2.dudebox_key.name}"
  floating_ip     = "${openstack_compute_floatingip_v2.dudebox_fip.address}"
  # availability_zone = "${var.avl1_name}"
  network {
    uuid = "${openstack_networking_network_v2.dudenet.id}"
  }

  connection {
    user = "${var.user_name}"
    key_file = "${file(var.private_key_main)}"
    host = "${openstack_compute_floatingip_v2.dudebox_fip.address}"
  }

  provisioner "file" {
    source = "provision_vm.sh"
    destination = "/home/${var.user_name}/provision_vm.sh"
  }
  provisioner "remote-exec"{
    inline = [
      "bash /home/${var.user_name}/provision_vm.sh"
    ]
  }
}

# Outputs -----------------------------------------

output "dudebox" {
  value = "${openstack_compute_instance_v2.dudebox.floating_ip}"
}
output "keyfile" {
  value = "${var.private_key_main}"
}
output "username" {
  value = "${var.user_name}"
}

output "connection command" {
  value = "ssh -i ${var.private_key_main} ${var.user_name}@${openstack_compute_instance_v2.dudebox.floating_ip}"
}

output "os_username" {
  value = "${var.os_username}"
}

output "os_tenant_name" {
  value = "${var.os_tenant_name}"
}

output "os_auth_url" {
  value = "${var.os_auth_url}"
}

output "os_region" {
  value = "${var.os_region}"
}
