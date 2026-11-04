variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "log_analytics_workspace_name" {
  type = string
}

variable "app_insights_name" {
  type = string
}
