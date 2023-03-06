# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Configure the Microsoft Azure Resource Group
resource "azurerm_resource_group" "chatgpt_rg" {
  name     = var.chatgpt_rg_name
  location = var.chatgpt_rg_location
}

resource "azurerm_api_management" "chatgpt_apim" {
  name                = var.chatgpt_apim_name
  location            = azurerm_resource_group.chatgpt_rg.location
  resource_group_name = azurerm_resource_group.chatgpt_rg.name
  publisher_name      = var.chatgpt_apim_publisher_name
  publisher_email     = var.chatgpt_apim_publisher_email
  sku_name = "Consumption_0"
}

resource "azurerm_api_management_api" "chatgpt_apim_api" {
  name                = "chatgpt_api"
  resource_group_name = azurerm_resource_group.chatgpt_rg.name
  api_management_name = azurerm_api_management.chatgpt_apim.name
  revision            = "1"
  api_type            = "http"
  display_name        = "ChatGPT API"
  service_url         = "https://api.openai.com/"
  protocols           = ["https"]
  subscription_required = false
}


resource "azurerm_api_management_api_operation" "chatgpt_apim_api_post_forward" {
  operation_id        = "forward_post_request"
  api_name            = azurerm_api_management_api.chatgpt_apim_api.name
  api_management_name = azurerm_api_management_api.chatgpt_apim_api.api_management_name
  resource_group_name = azurerm_api_management_api.chatgpt_apim_api.resource_group_name
  display_name        = "Forward POST Request"
  method              = "POST"
  url_template        = "/*"
  description         = "Forward POST Operation"
}

resource "azurerm_api_management_api_operation" "chatgpt_apim_api_get_forward" {
  operation_id        = "forward_get_request"
  api_name            = azurerm_api_management_api.chatgpt_apim_api.name
  api_management_name = azurerm_api_management_api.chatgpt_apim_api.api_management_name
  resource_group_name = azurerm_api_management_api.chatgpt_apim_api.resource_group_name
  display_name        = "Forward GET Request"
  method              = "GET"
  url_template        = "/*"
  description         = "Forward GET Operation"
}

resource "azurerm_api_management_api_operation" "chatgpt_apim_api_delete_forward" {
  operation_id        = "forward_delete_request"
  api_name            = azurerm_api_management_api.chatgpt_apim_api.name
  api_management_name = azurerm_api_management_api.chatgpt_apim_api.api_management_name
  resource_group_name = azurerm_api_management_api.chatgpt_apim_api.resource_group_name
  display_name        = "Forward Delete Request"
  method              = "DELETE"
  url_template        = "/*"
  description         = "Forward Delete Operation"
}