output "edc_windows_details" {
  value = {
    instance_private_ip = module.EDC_WINDOWS_STUDENT.instances.private_ip,
    instance_public_ip  = module.EDC_WINDOWS_STUDENT.instances.public_ip,
    ocid                = module.EDC_WINDOWS_STUDENT.instances.id,
    hostname            = module.EDC_WINDOWS_STUDENT.instances.display_name,
    os                  = var.edc_windows_properties["os"],
    username            = var.edc_windows_properties["username"],
    password            = var.edc_windows_properties["passwd"]
  }
}

output "ambari_details" {
  value = {
    instance_private_ip = module.AMBARI.instances.private_ip,
    instance_public_ip  = module.AMBARI.instances.public_ip,
    ocid                = module.AMBARI.instances.id,
    hostname            = module.AMBARI.instances.display_name,
    os                  = var.ambari_properties["os"],
    username            = var.ambari_properties["username"],
    password            = var.ambari_properties["passwd"]
  }
}

output "data_catalog_details" {
  value = {
    instance_private_ip = module.DATA_CATALOG.instances.private_ip,
    instance_public_ip  = module.DATA_CATALOG.instances.public_ip,
    ocid                = module.DATA_CATALOG.instances.id,
    hostname            = module.DATA_CATALOG.instances.display_name,
    os                  = var.data_catalog_properties["os"],
    username            = var.data_catalog_properties["username"],
    password            = var.data_catalog_properties["passwd"]
  }
}

output "pcr_s_details" {
  value = {
    instance_private_ip = module.PCR_S.instances.private_ip,
    instance_public_ip  = module.PCR_S.instances.public_ip,
    ocid                = module.PCR_S.instances.id,
    hostname            = module.PCR_S.instances.display_name,
    os                  = var.pcr_s_properties["os"],
    username            = var.pcr_s_properties["username"],
    password            = var.pcr_s_properties["passwd"]
  }
}