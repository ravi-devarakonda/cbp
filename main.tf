# Run instance modules to deploy instances
module "EDC_WINDOWS_STUDENT" {
  source           = "./module-instance"
  subnet_id        = var.pubsubid[var.region]
  instance_shape   = var.edc_windows_properties["shape"]
  instance_ad      = data.oci_identity_availability_domains.ads.availability_domains[var.adindex].name
  vmname           = var.edc_windows_properties["vmname"]
  image            = var.image_ocid_edc_windows[var.region]
  TrainingPortal   = var.TrainingPortal
  classname        = var.classname
  appid            = var.appid
  costtag          = var.costtag
  assign_public_ip = "true"
}

module "AMBARI" {
  source         = "./module-instance"
  subnet_id      = var.privsubid[var.region]
  instance_shape = var.ambari_properties["shape"]
  instance_ad    = data.oci_identity_availability_domains.ads.availability_domains[var.adindex].name
  vmname         = var.ambari_properties["vmname"]
  image          = var.image_ocid_ambari[var.region]
  TrainingPortal = var.TrainingPortal
  classname      = var.classname
  appid          = var.appid
  costtag        = var.costtag
}

module "PCR_S" {
  source         = "./module-instance"
  subnet_id      = var.privsubid[var.region]
  instance_shape = var.pcr_s_properties["shape"]
  instance_ad    = data.oci_identity_availability_domains.ads.availability_domains[var.adindex].name
  vmname         = var.pcr_s_properties["vmname"]
  image          = var.image_ocid_pcr_s[var.region]
  TrainingPortal = var.TrainingPortal
  classname      = var.classname
  appid          = var.appid
  costtag        = var.costtag
}

module "DATA_CATALOG" {
  source         = "./module-instance"
  subnet_id      = var.privsubid[var.region]
  instance_shape = var.data_catalog_properties["shape"]
  instance_ad    = data.oci_identity_availability_domains.ads.availability_domains[var.adindex].name
  vmname         = var.data_catalog_properties["vmname"]
  image          = var.image_ocid_data_catalog[var.region]
  TrainingPortal = var.TrainingPortal
  classname      = var.classname
  appid          = var.appid
  costtag        = var.costtag
}

#introduce delay to avoid race condition
resource null_resource "delay" {
  depends_on = [
    module.EDC_WINDOWS_STUDENT,
    module.AMBARI,
    module.PCR_S,
    module.DATA_CATALOG,
  ]
  provisioner "local-exec" {
    command = "sleep 2m"
  }
}

#run provisioners for remote script execution
resource "null_resource" "update_hosts" {
  depends_on = [
    null_resource.delay,
  ]

  provisioner "file" {
    content     = data.template_file.winhosts.rendered
    destination = "C:/Windows/System32/drivers/etc/hosts"
    #
    connection {
      type     = "winrm"
      user     = var.edc_windows_properties["username"]
      password = var.edc_windows_properties["passwd"]
      timeout  = "5m"
      host     = module.EDC_WINDOWS_STUDENT.instances.private_ip
    }
  }

  provisioner "file" {
    content     = data.template_file.winhosts.rendered
    destination = "C:/Windows/System32/drivers/etc/hosts"
    #
    connection {
      type     = "winrm"
      user     = var.pcr_s_properties["username"]
      password = var.pcr_s_properties["passwd"]
      timeout  = "5m"
      host     = module.PCR_S.instances.private_ip
    }
  }

  provisioner "file" {
    content     = data.template_file.linhosts.rendered
    destination = "$HOME/hosts"
    #
    connection {
      type     = "ssh"
      user     = var.ambari_properties["username"]
      password = var.ambari_properties["passwd"]
      timeout  = "5m"
      host     = module.AMBARI.instances.private_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv $HOME/hosts /etc/",
    ]
    #
    connection {
      type     = "ssh"
      user     = var.ambari_properties["username"]
      password = var.ambari_properties["passwd"]
      timeout  = "5m"
      host     = module.AMBARI.instances.private_ip
    }
  }

  provisioner "file" {
    content     = data.template_file.linhosts.rendered
    destination = "$HOME/hosts"
    #
    connection {
      type     = "ssh"
      user     = var.data_catalog_properties["username"]
      password = var.data_catalog_properties["passwd"]
      timeout  = "5m"
      host     = module.DATA_CATALOG.instances.private_ip
    }
  }


  provisioner "remote-exec" {
    inline = [
      "sudo mv $HOME/hosts /etc/",
    ]
    #
    connection {
      type     = "ssh"
      user     = var.data_catalog_properties["username"]
      password = var.data_catalog_properties["passwd"]
      timeout  = "5m"
      host     = module.DATA_CATALOG.instances.private_ip
    }
  }
}

#stop the windows instance after updating hosts file
 resource null_resource "stop-instance" {
  depends_on = [null_resource.update_hosts]
  provisioner "local-exec" {
    command = "sleep 1m;export OCI_CLI_AUTH=instance_principal;oci compute instance action --instance-id ${module.EDC_WINDOWS_STUDENT.instances.id} --action STOP;oci compute instance action --instance-id ${module.AMBARI.instances.id} --action STOP;oci compute instance action --instance-id ${module.PCR_S.instances.id} --action STOP;oci compute instance action --instance-id ${module.DATA_CATALOG.instances.id} --action STOP"
  }
} 
