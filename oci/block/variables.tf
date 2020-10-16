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
    shape = "VM.Standard2.16"
    #shape = "VM.Standard.E2.8"
    #shape = "BM.DenseIO1.36"
    #shape = "VM.DenseIO2.16"
    node_count = 4
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Constants
# You probably don't need to change these.
# ---------------------------------------------------------------------------------------------------------------------

// https://docs.cloud.oracle.com/iaas/images/image/cf34ce27-e82d-4c1a-93e6-e55103f90164/
// Oracle-Linux-7.5-2018.10.16-0
// ocid1.image.oc1.iad.aaaaaaaageeenzyuxgia726xur4ztaoxbxyjlxogdhreu3ngfj2gji3bayda
// Oracle-Linux-7.6-2018.11.19-0
// ocid1.image.oc1.iad.aaaaaaaa2mnepqp7wn3ej2axm2nkoxwwcdwf7uc246tcltg4li67z6mktdiq
// CentOS-7-2018.12.18-0
// ocid1.image.oc1.iad.aaaaaaaarsu56scul4muz3sqbptvykipy2rn6re3wzdjvncgcpgqt5cp3wja
variable "images" {
  type = "map"
  default = {
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaay5zmocfjtqjwsdr2vhwcopc32rcz764lsc76crhv2blbyr6azlqq"

    # Centos 7 latest
    us-ashburn-1 = "ocid1.image.oc1.iad.aaaaaaaatsqxhwfybqdv3knwtyacy27rgjuceb7756fcvmvxb3c5h6fvlk4a"
    #us-ashburn-1 = "ocid1.image.oc1.iad.aaaaaaaa2mnepqp7wn3ej2axm2nkoxwwcdwf7uc246tcltg4li67z6mktdiq"
  }
}
