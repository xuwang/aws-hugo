######################################
#
#   Module Arguments for HUGO site
#

# prefix for all hugo site buckets
# s3 bucket requires gloable unique bucket name, make sure set a prefix bucket 
# to make the bucket name unique
variable "prefix" {
    default = "hugo"
}

# web site FQDN
variable "www_fqdn" {
    default = "www.example.com"
}

# www bucket policy template, $${bucket_name} should be supplied by caller.
variable "html_policy_tmpl" {
    default = "artifacts/policies/html-bucket-policy.tmpl"
}

variable "lambda_role_policy_tmpl" {
    default = "artifacts/policies/lambda-role-policy.tmpl"
}
