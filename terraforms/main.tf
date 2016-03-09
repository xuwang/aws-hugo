# Call hugo module

module "hugo" {
    source = "../modules/hugo"
    prefix="${var.hugo_site.prefix}"
    www_fqdn="${var.hugo_site.fqdn}"
}