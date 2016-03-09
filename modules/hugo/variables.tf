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
                "arn:aws:s3:::$${bucket_name}/*"
            ]
        }
    ]
}
EOT
}

variable "lambda_role_policy_tmpl" {
    default = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets"
            ],
            "Resource": [
                "arn:aws:s3:::*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::$${source_bucket_name}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::$${source_bucket_name}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::$${html_bucket_name}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:DeleteObject",
                "s3:GetObject",
                "s3:PutObject",
                "s3:GetObjectAcl",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::$${html_bucket_name}/*"
            ]
        }
    ]
}
EOF
}