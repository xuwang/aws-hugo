# Call hugo module

module "hugo" {
    source = "../modules/hugo"
    bucket_prefix="${var.hogo_site.bucket_prefix}"
    www_fqdn="${var.hogo_site.fqdn"}
}