# Terraform Multi-VM Template for Informatica Training Platform
This Terraform template is for Multi-VM Blueprints that Informatica creates in their Training Platform application. <br/> This template, makes use of existing Public and Private Subnets in a given region and provisions Windows/Linux machines, based on the custom image `ocid`'s that are added to the `variables.tf` file.

**Please note**, We are not passing any ssh keys in case of Linux and the VM initial password is not changed, in case of Windows, via the script, because, we are using informatica provided custom images.<br/> 
Logic modification is required in the script, for passing Keys or changing the Initial Password

## OCI Environment

For this Terraform script to work, the OCI environemnt should have an extsting Network setup with a Provisioned VCN and other network components underneath like, Public & Private Subnets.

Defined tag-space named `TrainingPortal` should be created and `classanme`, `appid` and `costbucket` should be added as tag keys. (Preferably, created in root)

## Template hierarchy
We have `.tf` files in this template in the source dir.
- `versions.tf`  - has terraform version requirements
- `provider.tf`  - has OCI provider block
- `variables.tf` - all env and other variables
- `main.tf`      - has the logic which calls `instance` module
- `data.tf`      - has data resources to get Availability Domains in a region. It also has data resources to render hosts file for Windows & Linux. This generated hosts file is then uploaded to all the instances to the `etc` directory 
- `all_outputs.tf` - This file generates outputs for all instances provisioned via this template

We have two directories: `module-instance` and `config` under the source dir:

### `module-instance`:
- `instance.tf` - which has actual logic to provision an instance
- `outputs.tf`  - which has all instance attributes exported 

### `config`:
- `hosts.tpl` - template to generate hosts file

## `variables.tf`
The `variables.tf` file needs altering, to match the blueprint's requirement. The file structure is different than what we have in single-vm blueprint.

All the parameters that need changing are grouped into a single map variable. An example below:

```
variable "vm_name_properties" {
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
```
based on the number of VMs the blueprint holds, this map variable needs duplicating. for example, if there are 3 VMs in a blueprint, there would be 3 variables like the one above, with changes to the variable name, and values of the parameters in the variable. 

Also, make sure to add  variables `var.image_ocid_****` based on the number of instances and values to match image ocids of the instance per region. example:
```
variable "image_ocid_ambari" {
  type = map(string)
  default = {
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaazvkjsahfkjsnflkjdsfhdslkfjsakjfds"
    us-ashburn-1   = "ocid1.image.oc1.phx.aaaaaaaazvkjsahfkjkigfhjsvclihsljlvhlkj"
    eu-frankfurt-1 = "ocid1.image.oc1.phx.aaaaaoifjsdvcjhclsnb.ckjsbvclvdsvlsnvv"
    uk-london-1    = "ocid1.image.oc1.phx.aaaaaaaazvkjsahfkjsnflkjdsfhdsllkajdks"
    ap-mumbai-1    = "ocid1.image.oc1.phx.aaaaaosdkjdsflkdsjfsjhfdjsakjfds"
  }
}
```

## `main.tf`

The `main.tf` file also is a new addition in the multi-vm template. <br>
This file has `modules` based on the number of instances being provisioned. From the example above, we would have 3 modules added to the file. An example for adding a module below:

```
module "EDC_WINDOWS_STUDENT" {
  source           = "./module-instance"
  subnet_id        = var.pubsubid[var.region]
  instance_shape   = var.vm_name_properties["shape"]
  instance_ad      = data.oci_identity_availability_domains.ads.availability_domains[var.adindex].name
  vmname           = var.vm_name_properties["vmname"]
  image            = var.image_ocid_edc_windows[var.region]
  TrainingPortal   = var.TrainingPortal
  classname        = var.classname
  appid            = var.appid
  costtag          = var.costtag
  assign_public_ip = "true"
}
```

The `main.tf` file also has three `null_resource` blocks. The first one adds a delay before the script proceeds to the next block. <br>
The second one has `file` and `remote-exec` provisioners. Parameter values in provisioners have to be changed based on the map variables created in variab;es file. 
The final block has a `local-exec` provisioner which runs an OCI-CLI command to stop all provisioned scripts.<br>
**Please refer the existing template to see how the provisioner blocks are coded.**

## `data.tf`

the `data.tf` file has two `template_file` data blocks which are used to render hosts file for Windows and Linux machines. 
- `data "template_file" "winhosts"{}`
- `data "template_file" "linhosts"{}` 
Make sure to modify the parameter values based on the variables file.

## Testing 
Variables, `region`, `classname`, `appid` & `costtag` are passed from the front-end. For simulation, pass them during run-time.

**command:**
```
terraform apply -var region="region-name" -var classname="class-name" -var appid="appid" -var costtag="costtag" -auto-approve
```

>**Disclaimer-1**: _Please note, any modifications that are made, other than, what is mentioned above, may need a different deployment approach or may break the script._

>**Disclaimer-2**: This is a personal repository. All code, views or opinions, and any other content represented here are personal and belong solely to me and do not represent those of people, institutions or organizations that I may or may not be associated with in professional or personal capacity, unless explicitly stated.<br>
<br>*Also **please note**, resources deployed using these example scripts do incur charges. Make sure to terminate the deployed resources/services after your tests, to save/minimize your bills*
