variable "subnet_id" {}
variable "instance_shape" {}
variable "vmname" {}
variable "image" {}
variable "instance_ad" {}
variable "TrainingPortal" {}
variable "classname" {}
variable "appid" {}
variable "costtag" {}
variable "assign_public_ip" {
  default = "false"
}

#deploy the instance
resource "oci_core_instance" "CreateInstance" {
  #Required
  availability_domain = var.instance_ad
  compartment_id      = var.TrainingPortal
  shape               = var.instance_shape
  display_name        = "${var.classname}-${var.appid}-${var.vmname}"
  #state               = var.state

  #Optional
  source_details {
    source_id   = var.image
    source_type = "image"
  }

  #Optional
  create_vnic_details {
    #Required
    subnet_id        = var.subnet_id
    assign_public_ip = var.assign_public_ip

    #Optional
    display_name = "${var.classname}-${var.appid}-${var.vmname}"
    #hostname_label = random_string.myhost.result
  }

  #defined tags
  defined_tags = {
    "TrainingPortal.appname"    = "${var.classname}-${var.appid}",
    "TrainingPortal.costbucket" = var.costtag
  }
}