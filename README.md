# Automation Overview
This terraform workspace will generate the following setup:

* Keypair "dudebox_key" ([security_setup.tf](security_setup.tf))
* Security Groups ([security_setup.tf](security_setup.tf))
  * "dudenet_ssh" - allows ssh connections
  * "dudenet_ping" - allows ping connections
* Network "dudenet" ([network_setup.tf](network_setup.tf))
  * Sub-network "dudenet_subnet1"
* Router "dudenet_router" ([network_setup.tf](network_setup.tf))
  * Router interface "dudenet_subnet1_router_interface" -> "dudenet_subnet1"
* VM "dudebox" ([main.tf](main.tf))
  * in network dudenet_subnet1
  * with an attached floating ip
  * with security groups "dudenet_ssh", "dudenet_ping"
  * runs the provisioner script ([provision_vm.sh](provision_vm.sh))

## Pre-requisites
* Install terraform: https://www.terraform.io/downloads.html

## Create a ssh key for the systems
```
# Generate a key under your ssh directory
# Attention don't replace your own key
ssh-keygen -t rsa -b 8192 -f $HOME/.ssh/YOUR_KEY_NAME
```

## Configuration preparation
```
cp configuration.tfvars.example configuration.tfvars
vim configuration.tfvars # Adjust all settings in capital letters
# Replace the key file locations with the generated keypair
```

## Plan
Terraform will print out a plan for the infrastructure components.

```
terraform plan -var-file="configuration.tfvars"
```

## Run setup
Terraform will run the setup. This can take some time.

```
terraform apply -var-file="configuration.tfvars"
```


## Destroy setup
ATTENTION! This will destroy the complete setup!

```
terraform destroy -var-file="configuration.tfvars"
```

## Hint on errors
In case of errors re-execute the command to continue the process.
Watch for errors in the provision process of the VM.
The provisioning script should be completed because this will only run once per each VM.
When other errors occur just re-execute the terraform command.
