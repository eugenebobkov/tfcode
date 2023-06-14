variable "azure_region" {
  default     = "australiasoutheast"
  description = "Azure region for resource location"
}

variable "gmf_resource_group_name_prefix" {
  default     = "rg_gmf"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}
