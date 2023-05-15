terraform {
  backend "azurerm" {
    storage_account_name = "cs110032001fc8b8730"
    container_name = "terraform-state"
    key = "terraform.tfstate"
  }
}