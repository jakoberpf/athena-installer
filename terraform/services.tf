module "zelos_system_service_external_secrets" {
  source = "/Users/jakoberpf/Code/jakoberpf/terraform/modules/kubernetes/external-secrets-deployment" # "jakoberpf/external-secrets-deployment/kubernetes"

  compartment = "athena-installer"

  vault_server = var.vault_server
  vault_token = var.vault_token
}

module "zelos_system_service_cert_manager" {
  source            = "jakoberpf/certmanager-deployment/kubernetes"

  # compartment = "athena-installer"
  
  deploy_manager    = true # TODO remove and make default
  deploy_reflector  = true # TODO remove and make default
  cloudflare_tokens = var.cloudflare_tokens
}

module "zelos_system_service_longhorn" {
  depends_on = [
    module.zelos_system_service_cert_manager
  ]

  source = "/Users/jakoberpf/Code/jakoberpf/terraform/modules/kubernetes/longhorn-deployment" # "jakoberpf/longhorn-deployment/kubernetes"

  compartment                = "athena-installer"
  
  aws_access_key_id          = var.longhorn_aws_access_key_id
  aws_secret_access_key      = var.longhorn_aws_secret_access_key

  ingress_dns                = var.longhorn_ingress_dns

  gatekeeper_client_id       = var.longhorn_gatekeeper_client_id
  gatekeeper_client_secret   = var.longhorn_gatekeeper_client_secret
  gatekeeper_encryption_key  = var.longhorn_gatekeeper_encryption_key
  gatekeeper_redirection_url = var.longhorn_gatekeeper_redirection_url
  gatekeeper_discovery_url   = var.longhorn_gatekeeper_discovery_url
}

module "zelos_system_service_monitoring" {
  depends_on = [
    module.zelos_system_service_cert_manager,
    module.zelos_system_service_longhorn
  ]

  source = "/Users/jakoberpf/Code/jakoberpf/terraform/modules/kubernetes/monitoring-deployment" # "jakoberpf/monitoring-deployment/kubernetes"

  compartment           = "athena-installer"

  ingress_dns           = var.grafana_ingress_dns # TODO rename to grafana_ingress_dns
  grafana_adminPassword = var.grafana_adminPassword
  grafana_root_url      = var.grafana_root_url
  grafana_client_id     = var.grafana_client_id
  grafana_client_secret = var.grafana_client_secret
  grafana_auth_url      = var.grafana_auth_url
  grafana_token_url     = var.grafana_token_url
  grafana_api_url       = var.grafana_api_url

  # prometheus_ingress_dns   = var.grafana_ingress_dns
  # prometheus_adminPassword = var.grafana_adminPassword
  # prometheus_root_url      = var.grafana_root_url
  # prometheus_client_id     = var.grafana_client_id
  # prometheus_client_secret = var.grafana_client_secret
  # prometheus_auth_url      = var.grafana_auth_url
  # prometheus_token_url     = var.grafana_token_url
  # prometheus_api_url       = var.grafana_api_url
}

# module "zelos_system_service_flux" {
#   source = "jakoberpf/flux-deployment/kubernetes"

#   github_owner    = var.github_owner
#   github_token    = var.github_token
#   repository_name = var.repository_name
#   branch          = var.branch
#   stage           = var.stage
# }
