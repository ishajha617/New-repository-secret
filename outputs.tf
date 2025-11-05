output "web_app_url" {
  value = "https://${azurerm_linux_web_app.webapp.name}.azurewebsites.net"
}

output "storage_account_name" {
  value = azurerm_storage_account.sa.name
}
