variable "project_resourcegroup_name" {
  description = "The name of the resource group for the project"
  type        = string
  default     = "explore-azure-active-directory-b2c-project-gwc-rg"

}

variable "default_tags" {
  description = "The default tags for all resources"
  type        = map(string)
  default = {
    "project" = "explore-azure-active-directory-b2c"
  }
}

variable "westeurope_location" {
  description = "The location for the resources"
  type        = string
  default     = "westeurope"
}

variable "germanywestcentral_location" {
  description = "The location for the resources"
  type        = string
  default     = "germanywestcentral"
}

variable "northeurope_location" {
  description = "The location for the resources"
  type        = string
  default     = "northeurope"
}
