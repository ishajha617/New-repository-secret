variable "resource_group_name" {
  default = "rg-webapp-demo"
}

variable "location" {
  default = "Central US"  # ✅ region with more quota
}

variable "storage_account_name" {
  default = "webappstorage1234"
}

variable "service_plan_name" {
  default = "appserviceplan-demo"
}

variable "web_app_name" {
  default = "webapp-demo123"
}
