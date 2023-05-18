Terraform Repo: https://github.com/akshayahuja2187/allianz-tech-terraform
This contains terraform code to create resource group, vnet, subnet, NIC, Public IP, NSG, security rules, VM to host jenkins instance alongwith terraform state being maintained in azure storage account.
Also contains the terraform.yaml workflow using Github actions to run a pipeline to do az login, terraform init, terraform validate & terraform apply on Github provided runner.

This is an early version, it can be further enhanced to include installation script for installing softwares post the VM creation, such as:

# Install openjdk-11-jre
sudo apt-get update
sudo apt-get install openjdk-11-jre
# Install jenkins
sudo apt-get install jenkins
# Install git
sudo apt-get install git
# Install docker
sudo apt-get install docker
# Install k3d
sudo apt-get install k3d
# Install kubectl
sudo apt-get install kubectl

We can also additionally create self-hosted runner to run the github workflow actions or create a jenkins pipeline for the same steps.
Security enhancement can be creating an azure keyvault and key generation for the Jenkins VM. As well as credentials for Jenkins admin.
We can also create service principal using terraform to assign azure role.
We can also further enhance the terraform pipeline to include tests and also modify it to ensure that the terraform apply stage is run when the code is merged to main after PR process with review from leads and Infosec to ensure that all firewall and networking rules are in adherance to security policy and do not allow any unwanted traffic.
