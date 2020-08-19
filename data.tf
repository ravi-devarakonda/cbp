#get ADs
# Get a list of Availability Domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

#create Windows hosts template file to push it to Public Windows instance
data "template_file" "winhosts" {
  template = file("config/hosts.tpl")
  vars = {
    #don't touch this variable
    new_line = "\r\n"
    #private ip's
    ambari_ip       = module.AMBARI.instances.private_ip
    pcr_s_ip        = module.PCR_S.instances.private_ip
    data_catalog_ip = module.DATA_CATALOG.instances.private_ip
    #hostnames
    ambari_hostname       = var.ambari_properties["hostname"]
    data_catalog_hostname = var.data_catalog_properties["hostname"]
    pcr_s_hostname        = var.pcr_s_properties["hostname"]

  }
}

#create hosts template file to push it to Public Windows instance
data "template_file" "linhosts" {
  template = file("config/hosts.tpl")
  vars = {
    #don't touch this variable
    new_line = "\n"
    #private ip's
    ambari_ip       = module.AMBARI.instances.private_ip
    pcr_s_ip        = module.PCR_S.instances.private_ip
    data_catalog_ip = module.DATA_CATALOG.instances.private_ip
    #hostnames
    ambari_hostname       = var.ambari_properties["hostname"]
    data_catalog_hostname = var.data_catalog_properties["hostname"]
    pcr_s_hostname        = var.pcr_s_properties["hostname"]

  }
}
