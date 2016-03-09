######################################
#
#   Module Arguments for HUGO site
#

# prefix for all hugo site buckets
# s3 bucket requires gloable unique bucket name, make sure set a prefix bucket 
# to make the bucket name unique
variable "bucket_prefix" {
    default = "hugo"
}

# web site FQDN
variable "www_fqdn" {
    default = "www.example.com"
}

# www bucket policy template, ${bucket_name} should be supplied by caller.
variable "html_policy_tmpl" {
    default = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${bucket_name}/*"
            ]
        }
    ]
}
EOT
}