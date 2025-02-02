locals {
  sa = {
    frontend = {
      replicas = [
        {
          name     = "eaadb2cpfe${terraform.workspace}gwcsa"
          location = var.germanywestcentral_location
        },
        {
          name     = "eaadb2cpfe${terraform.workspace}weusa"
          location = var.westeurope_location
        },
        {
          name     = "eaadb2cpfe${terraform.workspace}neusa"
          location = var.northeurope_location
        }
      ]
    }
  }
}

resource "azurerm_storage_account" "frontend_replicas" {
  count                    = length(local.sa.frontend.replicas)
  name                     = local.sa.frontend.replicas[count.index].name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = local.sa.frontend.replicas[count.index].location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  is_hns_enabled = false

  tags = merge(var.default_tags, {
    "env" = terraform.workspace
  })
}

resource "azurerm_storage_account_static_website" "test" {
  count              = length(local.sa.frontend.replicas)
  storage_account_id = azurerm_storage_account.frontend_replicas[count.index].id
  error_404_document = "index.html"
  index_document     = "index.html"
}

resource "azurerm_storage_container" "frontend_replicas" {
  count                 = length(local.sa.frontend.replicas)
  name                  = "$web"
  storage_account_id    = azurerm_storage_account.frontend_replicas[count.index].id
  container_access_type = "blob"
}
