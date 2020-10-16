resource "oci_core_instance" "dse" {
  display_name        = "bare-${count.index}"
  compartment_id      = "${var.compartment_ocid}"
  availability_domain = "YVsm:US-ASHBURN-AD-2"
#"${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[1],"name")}"
  shape               = "${var.dse["shape"]}"
  subnet_id           = "${oci_core_subnet.subnet.id}"
  source_details {
    source_id = "${var.images[var.region]}"
  	source_type = "image"
  }

  create_vnic_details {
        subnet_id = "${oci_core_subnet.subnet.id}"
        hostname_label = "dse-${count.index}"
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data           = "${base64encode(join("\n", list(
      "#!/usr/bin/env bash",
      file("./cstar.sh")
    )))}"
  }
  count = "${var.dse["node_count"]}"
}

output "Node public IPs" { value = "${join(",", oci_core_instance.dse.*.public_ip)}" }
output "Node private IPs" { value = "${join(",", oci_core_instance.dse.*.private_ip)}" }
