provider "azurerm" {
  subscription_id            = var.subscription_id
  client_id                  = var.client_id
  client_secret              = var.client_secret
  tenant_id                  = var.tenant_id
  skip_provider_registration = true
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "cloud-shell-storage-southeastasia"
      storage_account_name = "cs110032001fc8b8730"
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
  }
}