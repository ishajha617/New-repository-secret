############################################
# Resource Group
############################################
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

############################################
# Storage Account
############################################
resource "azurerm_storage_account" "sa" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

############################################
# Service Plan (Linux)
############################################
# Use Free (F1) tier to avoid quota/unauthorized errors
resource "azurerm_service_plan" "sp" {
  name                = var.service_plan_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"   # ✅ changed from "B1" to "F1" (Free tier)
}

############################################
# Linux Web App
############################################
resource "azurerm_linux_web_app" "webapp" {
  name                = var.web_app_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.sp.id

  site_config {
    always_on = false  # ❗ must be false for F1 plan (Free tier doesn’t support Always On)
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "true"
    "PYTHON_VERSION"                      = "3.11"
  }

  depends_on = [azurerm_service_plan.sp]
}

############################################
# Application Insights
############################################
resource "azurerm_application_insights" "ai" {
  name                = "${var.web_app_name}-ai"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
}
