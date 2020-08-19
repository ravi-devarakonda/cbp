#
# DO NOT MODIFY THESE VARIABLES AND THEIR VALUES. ANY CHANGE HERE MIGHT BREAK THE DEPLOYMENT
#
variable "tenancy_ocid" {
  type    = string
  default = "ocid1.tenancy.oc1..aaaaaaaavijeuzmg3qs5sgvrkg3mlv4ndg6ejss3lhu3qbyslacfpa2uprhq"
}

variable "region" {
  type    = string
  default = "us-phoenix-1"
}

variable "TrainingPortal" {
  type    = string
  default = "ocid1.compartment.oc1..aaaaaaaa2mmc5uq35p6edotjuoc5d5m2riasipv3fykpbt5scrk76blmwxmq"
}

variable "TP_Stage" {
  type    = string
  default = "ocid1.compartment.oc1..aaaaaaaab6hnho7umkngugn7hkv3b5q6uxdobmxq3kezdkmbaimiscainuga"
}

variable "privsubid" {
  type = map
  default = {
    us-phoenix-1   = "ocid1.subnet.oc1.phx.aaaaaaaallp2vtqlfzwlhe5yf6b7ssj6giitkmrgsnawwuygauvj5enxu2oq"
    us-ashburn-1   = "ocid1.subnet.oc1.iad.aaaaaaaai5wu5cwnng5mzyfbfa5if6noujfzjgjmumyw4olrml7tq5awwsva"
    eu-frankfurt-1 = "ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaaw4jkbfguqvpehauibjitw5onc6utjc7d7okntqrullcebbe7m27q"
    uk-london-1    = "ocid1.subnet.oc1.uk-london-1.aaaaaaaan2glg7rqqq46xn67g6c7vh5pzgghjfyujmunxuzxdzwxy5lf62ma"
    ap-mumbai-1    = "ocid1.subnet.oc1.ap-mumbai-1.aaaaaaaawfssvfp76vtvw2qkllg2l3rss7eg6qwxf5ruixih4dwhhx5wsr6q"
  }
}

variable "pubsubid" {
  type = map
  default = {
    us-phoenix-1   = "ocid1.subnet.oc1.phx.aaaaaaaamdk66v7htcivnq2itandldghimeyp6pesvrculategekqyaf3exq"
    us-ashburn-1   = "ocid1.subnet.oc1.iad.aaaaaaaa6pcvdqpkmaxvqasafsx6wf3x27lkrrqzw6m5tg4w7osnugoax2cq"
    eu-frankfurt-1 = "ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaanzqj3sujnqyxwzb6nxgmv6u7pv54gaeo4drv6dcphokhdeep6c6q"
    uk-london-1    = "ocid1.subnet.oc1.uk-london-1.aaaaaaaabqbt4ecwwjsszyqoqdpcap23dbf2vaffbgzuywcq2dokq6q34bjq"
    ap-mumbai-1    = "ocid1.subnet.oc1.ap-mumbai-1.aaaaaaaatynncflg6izxndvzsozltjftsnbciojdkmxpnlcfybkhakdldieq"
  }
}

#
#THE BELOW VARIABLE VALUES COME FROM THE FRONT END.
#

variable "classname" {
  type    = string
  default = "default-classname"
}

variable "appid" {
  type    = string
  default = "default-appid"
}

variable "costtag" {
  type    = string
  default = "default-cost-tag"
}

variable "adindex" {
  default = "0"
}

#
# CHANGE THE VALUES OF THE BELOW VARIABLES BASED ON THE IMAGES IN THE BLUEPRINT
#

variable "edc_windows_properties" {
  type = map(string)
  default = {
    vmname = "EDC_Windows_Student01"
    shape  = "VM.Standard2.2"
    #hostname    = "edc_windows"
    os       = "windows"
    username = "Administrator"
    passwd   = "Ju$t1ce@!nf@"
  }
}

variable "ambari_properties" {
  type = map(string)
  default = {
    vmname   = "AMBARI"
    shape    = "VM.Standard2.2"
    os       = "linux"
    hostname = "infahadoop"
    username = "infauser"
    passwd   = "infa@123"
  }
}

variable "pcr_s_properties" {
  type = map(string)
  default = {
    vmname   = "pcr_s"
    shape    = "VM.Standard2.2"
    hostname = "infadata"
    os       = "windows"
    username = "Administrator"
    passwd   = "Ju$t1ce@!nf@"
  }
}

variable "data_catalog_properties" {
  type = map(string)
  default = {
    vmname   = "ENTERPRISE_DATA_CATALOG"
    shape    = "VM.Standard2.2"
    hostname = "infasats"
    os       = "linux"
    username = "infauser"
    passwd   = "infa@123"
  }
}

#Add OCIDs of blueprint images against each region
variable "image_ocid_edc_windows" {
  type = map(string)
  default = {
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaaqpintfdpjl5gtjze3uv4yt4q62p3zcj5sssprlhm2lg3ypzytchq"
    /*  us-ashburn-1   = ""
    eu-frankfurt-1 = ""
    uk-london-1    = ""
    ap-mumbai-1    = "" */
  }
}


variable "image_ocid_ambari" {
  type = map(string)
  default = {
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaazvjkowmuuq2k4wt6ydzay3leznu64mdhfg5ctmz3ikc6la3bzszq"
    /*  us-ashburn-1   = ""
    eu-frankfurt-1 = ""
    uk-london-1    = ""
    ap-mumbai-1    = "" */
  }
}

variable "image_ocid_pcr_s" {
  type = map(string)
  default = {
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaay6iyxgsznb23bviildjtgnivuxj66quo3le7bvw5edo63jqjkrra"
    ####us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaa5pwk57rs62izjqewngbgpsispfd3kzlqjgh6rcmzyww4klebrbha"
    /*  us-ashburn-1   = ""
    eu-frankfurt-1 = ""
    uk-london-1    = ""
    ap-mumbai-1    = "" */
  }
}

variable "image_ocid_data_catalog" {
  type = map(string)
  default = {
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaa4zmdlxk5nsxvedzurfsjnvjufjhayyv25vbc4lxluom2kiuxuguq"
    /*  us-ashburn-1   = ""
    eu-frankfurt-1 = ""
    uk-london-1    = ""
    ap-mumbai-1    = "" */
  }
}
