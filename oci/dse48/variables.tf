# ---------------------------------------------------------------------------------------------------------------------
# Environmental variables
# You probably want to define these as environmental variables.
# Instructions on that are here: https://github.com/cloud-partners/oci-prerequisites
# ---------------------------------------------------------------------------------------------------------------------

# Required by the OCI Provider
variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

# Key used to SSH to OCI VMs
variable "ssh_public_key" {}
variable "ssh_private_key" {}

# ---------------------------------------------------------------------------------------------------------------------
# Optional variables
# The defaults here will give you a cluster.  You can also modify these.
# ---------------------------------------------------------------------------------------------------------------------

variable "dse" {
  type = "map"
  default = {
    #shape = "VM.Standard2.4"
    #shape = "BM.DenseIO1.36"
    shape = "VM.DenseIO2.16"
    #shape = "VM.DenseIO2.8"
    node_count = 4
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Constants
# You probably don't need to change these.
# ---------------------------------------------------------------------------------------------------------------------

// https://docs.cloud.oracle.com/iaas/images/image/66379f54-edd0-4294-895f-47291a3eb4ed/
// Oracle-Linux-7.6-2019.02.20-0

// CentOS Linux release 7.6.1810 (Core)
// ocid1.image.oc1.eu-frankfurt-1.aaaaaaaay5zmocfjtqjwsdr2vhwcopc32rcz764lsc76crhv2blbyr6azlqq

variable "images" {
  type = "map"
  default = {
      ca-toronto-1 = "ocid1.image.oc1.ca-toronto-1.aaaaaaaa7ac57wwwhputaufcbf633ojir6scqa4yv6iaqtn3u64wisqd3jjq"
      eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa527xpybx2azyhcz2oyk6f4lsvokyujajo73zuxnnhcnp7p24pgva"
      uk-london-1	= "ocid1.image.oc1.uk-london-1.aaaaaaaarruepdlahln5fah4lvm7tsf4was3wdx75vfs6vljdke65imbqnhq"
      us-ashburn-1 = "ocid1.image.oc1.iad.aaaaaaaannaquxy7rrbrbngpaqp427mv426rlalgihxwdjrz3fr2iiaxah5a"
      us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaacss7qgb6vhojblgcklnmcbchhei6wgqisqmdciu3l4spmroipghq"
    }
}
