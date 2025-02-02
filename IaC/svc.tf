# resource "random_password" "github_actions_password" {
#   length  = 32
#   special = true
# }


resource "azuread_application" "github_actions" {
  display_name                       = "github-actions-app"
}

resource "azuread_service_principal" "github_actions" {
  client_id = azuread_application.github_actions.client_id
}

resource "azurerm_role_assignment" "github_actions" {
  principal_id         = azuread_service_principal.github_actions.object_id
  role_definition_name = "Contributor"
  scope = azurerm_resource_group.main.id
}
