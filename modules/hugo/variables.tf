######################################
#
#   Module Arguments for HUGO site
#

# root_domain for the hugo site
# the site FQDN will be www.${root_domain}
variable "root_domain" {
    default = "example.com"
}

# html bucket policy template, ${bucket_name} should be supplied by caller.
variable "html_policy_tmpl" {
    default = "artifacts/policies/html-bucket-policy.tmpl"
}

# used by lambda_function
variable "lambda_role_policy_tmpl" {
    default = "artifacts/policies/lambda-role-policy.tmpl"
}

# lambda_function payload
variable "lambda_function_tar_url" {
    #   Download link: Download Lambda function for Hugo
    #   MD5 checksum: 030c8b8432d069c734d968f3b150ed73
    default = "https://github.com/xuwang/aws-hugo/files/166363/hugo_aws_lambda_20151129.zip"
}

# used by iam hugo_user
variable "hugo_user_policy_tmpl" {
    default = "artifacts/policies/hugo-user-policy.tmpl"
}
