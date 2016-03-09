# Call hugo module

module "hugo" {
    source = "../modules/hugo"
    prefix="${var.hogo_site.prefix}"
    www_fqdn="${var.hogo_site.fqdn"}
}