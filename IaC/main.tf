resource "azurerm_resource_group" "main" {
  name     = "explore-azure-active-directory-b2c-${terraform.workspace}-gwc-rg"
  location = var.germanywestcentral_location

  tags = merge(var.default_tags, {
    "env" = terraform.workspace
  })

  lifecycle {
    precondition {
      condition = contains(
        ["dev", "qa", "prod"],
        terraform.workspace
      )
      error_message = "The workspace (env) should be either dev, qa, or prod."
    }
  }
}
