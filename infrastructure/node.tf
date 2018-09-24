resource "oci_core_instance" "datastax_node" {
  display_name        = "datastax_node"
  compartment_id      = "${var.tenancy_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  shape               = "${var.shape}"
  subnet_id           = "${oci_core_subnet.subnet.id}"
  source_details {
    source_id = "${var.images[var.region]}"
  	source_type = "image"
  }
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(file("./node.sh"))}"
  }
}

data "oci_core_vnic_attachments" "datastax_node_vnic_attachments" {
  compartment_id      = "${var.tenancy_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  instance_id         = "${oci_core_instance.datastax_node.*.id[0]}"
}

data "oci_core_vnic" "datastax_node_vnic" {
  vnic_id = "${lookup(data.oci_core_vnic_attachments.datastax_node_vnic_attachments.vnic_attachments[0],"vnic_id")}"
}

output "SSH" { value = "ssh -i ~/.ssh/oci opc@${data.oci_core_vnic.datastax_node_vnic.public_ip_address}" }
