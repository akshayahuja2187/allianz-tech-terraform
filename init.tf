provider "azurerm" {
  subscription_id            = ${{ secrets.AZURE_SUBSCRIPTION_ID }}
  tenant_id                  = ${{ secrets.AZURE_TENANT_ID }}
  client_id                  = ${{ secrets.AZURE_CLIENT_ID }}
  client_secret              = ${{ secrets.AZURE_CLIENT_SECRET }}
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