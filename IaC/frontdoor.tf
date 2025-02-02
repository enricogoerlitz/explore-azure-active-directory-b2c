resource "azurerm_cdn_frontdoor_profile" "main" {
  name                = "eaadb2c-${terraform.workspace}-gwc-fd"
  resource_group_name = azurerm_resource_group.main.name
  sku_name = "Premium_AzureFrontDoor"

  tags = merge(var.default_tags, {
    "env" = terraform.workspace
  })
}

resource "azurerm_cdn_frontdoor_endpoint" "enricogoerlitz" {
  name                     = "eaadb2c-endpoint-${terraform.workspace}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
  enabled                  = true
}

resource "azurerm_cdn_frontdoor_origin_group" "default_origin_group" {
  name                     = "default-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
  session_affinity_enabled = true

  load_balancing {
    sample_size                        = 4
    successful_samples_required        = 3
    additional_latency_in_milliseconds = 50
  }

  health_probe {
    path                = "/"
    request_type        = "HEAD"
    protocol            = "Https"
    interval_in_seconds = 100
  }
}

resource "azurerm_cdn_frontdoor_origin" "origins" {
    count = 1
  name                           = "default-origin"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.default_origin_group.id
  host_name                      = azurerm_storage_account.frontend_replicas[0].primary_web_endpoint # "eaadb2cpfedevgwcsa.z1.web.core.windows.net"
  https_port                     = 443
  origin_host_header             = azurerm_storage_account.frontend_replicas[0].primary_web_endpoint
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true
  enabled                        = true
}

resource "azurerm_cdn_frontdoor_route" "routes" {
  name                          = "default-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.enricogoerlitz.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.default_origin_group.id
cdn_frontdoor_origin_ids      = [for origin in azurerm_cdn_frontdoor_origin.origins : origin.id]
  supported_protocols           = ["Https"]

  patterns_to_match      = ["/*"]
  forwarding_protocol    = "MatchRequest"
  link_to_default_domain = true
  enabled                = true
}