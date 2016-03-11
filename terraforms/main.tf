# Call hugo module

module "hugo" {
    source = "../modules/hugo"
    root_domain="${var.hugo_site.root_domain}"
    www_fqdn="${var.hugo_site.fqdn}"
}