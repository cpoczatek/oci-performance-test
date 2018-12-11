
# block volumes for DSE nodes

# Volume 1
resource "oci_core_volume" "NodeVolume1" {
  count = "${var.dse["node_count"]}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "Node ${format("%01d", count.index)} Volume 1"
  size_in_gbs         = 3000
}

resource "oci_core_volume_attachment" "NodeAttachment1" {
  count = "${var.dse["node_count"]}"
  attachment_type = "iscsi"
  compartment_id  = "${var.compartment_ocid}"
  instance_id     = "${oci_core_instance.dse.*.id[count.index]}"
  volume_id       = "${oci_core_volume.NodeVolume1.*.id[count.index]}"
}

# Volume 2
resource "oci_core_volume" "NodeVolume2" {
  count = "${var.dse["node_count"]}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "Node ${format("%01d", count.index)} Volume 2"
  size_in_gbs         = 3000
}

resource "oci_core_volume_attachment" "NodeAttachment2" {
  count = "${var.dse["node_count"]}"
  attachment_type = "iscsi"
  compartment_id  = "${var.compartment_ocid}"
  instance_id     = "${oci_core_instance.dse.*.id[count.index]}"
  volume_id       = "${oci_core_volume.NodeVolume2.*.id[count.index]}"
}

# Volume 3
resource "oci_core_volume" "NodeVolume3" {
  count = "${var.dse["node_count"]}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "Node ${format("%01d", count.index)} Volume 3"
  size_in_gbs         = 3000
}

resource "oci_core_volume_attachment" "NodeAttachment3" {
  count = "${var.dse["node_count"]}"
  attachment_type = "iscsi"
  compartment_id  = "${var.compartment_ocid}"
  instance_id     = "${oci_core_instance.dse.*.id[count.index]}"
  volume_id       = "${oci_core_volume.NodeVolume3.*.id[count.index]}"
}
