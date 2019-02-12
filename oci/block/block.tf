
# block volumes for DSE nodes

# Volume 1
resource "oci_core_volume" "NodeVolume1" {
  count = "${var.dse["node_count"]}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "Node ${format("%01d", count.index)} Volume 1"
  size_in_gbs         = 700
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
  size_in_gbs         = 700
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
  size_in_gbs         = 700
}

resource "oci_core_volume_attachment" "NodeAttachment3" {
  count = "${var.dse["node_count"]}"
  attachment_type = "iscsi"
  compartment_id  = "${var.compartment_ocid}"
  instance_id     = "${oci_core_instance.dse.*.id[count.index]}"
  volume_id       = "${oci_core_volume.NodeVolume3.*.id[count.index]}"
}

# Volume 4
resource "oci_core_volume" "NodeVolume4" {
  count = "${var.dse["node_count"]}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "Node ${format("%01d", count.index)} Volume 4"
  size_in_gbs         = 700
}

resource "oci_core_volume_attachment" "NodeAttachment4" {
  count = "${var.dse["node_count"]}"
  attachment_type = "iscsi"
  compartment_id  = "${var.compartment_ocid}"
  instance_id     = "${oci_core_instance.dse.*.id[count.index]}"
  volume_id       = "${oci_core_volume.NodeVolume4.*.id[count.index]}"
}

# Volume 5
resource "oci_core_volume" "NodeVolume5" {
  count = "${var.dse["node_count"]}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "Node ${format("%01d", count.index)} Volume 5"
  size_in_gbs         = 700
}

resource "oci_core_volume_attachment" "NodeAttachment5" {
  count = "${var.dse["node_count"]}"
  attachment_type = "iscsi"
  compartment_id  = "${var.compartment_ocid}"
  instance_id     = "${oci_core_instance.dse.*.id[count.index]}"
  volume_id       = "${oci_core_volume.NodeVolume5.*.id[count.index]}"
}

# Volume 6
resource "oci_core_volume" "NodeVolume6" {
  count = "${var.dse["node_count"]}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "Node ${format("%01d", count.index)} Volume 6"
  size_in_gbs         = 700
}

resource "oci_core_volume_attachment" "NodeAttachment6" {
  count = "${var.dse["node_count"]}"
  attachment_type = "iscsi"
  compartment_id  = "${var.compartment_ocid}"
  instance_id     = "${oci_core_instance.dse.*.id[count.index]}"
  volume_id       = "${oci_core_volume.NodeVolume6.*.id[count.index]}"
}

# Volume 7
resource "oci_core_volume" "NodeVolume7" {
  count = "${var.dse["node_count"]}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "Node ${format("%01d", count.index)} Volume 7"
  size_in_gbs         = 700
}

resource "oci_core_volume_attachment" "NodeAttachment7" {
  count = "${var.dse["node_count"]}"
  attachment_type = "iscsi"
  compartment_id  = "${var.compartment_ocid}"
  instance_id     = "${oci_core_instance.dse.*.id[count.index]}"
  volume_id       = "${oci_core_volume.NodeVolume7.*.id[count.index]}"
}

# Volume 8
resource "oci_core_volume" "NodeVolume8" {
  count = "${var.dse["node_count"]}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "Node ${format("%01d", count.index)} Volume 8"
  size_in_gbs         = 700
}

resource "oci_core_volume_attachment" "NodeAttachment8" {
  count = "${var.dse["node_count"]}"
  attachment_type = "iscsi"
  compartment_id  = "${var.compartment_ocid}"
  instance_id     = "${oci_core_instance.dse.*.id[count.index]}"
  volume_id       = "${oci_core_volume.NodeVolume8.*.id[count.index]}"
}
