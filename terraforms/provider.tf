provider "aws" {
  access_key = "<your_aws_access_key>"
  secret_key = "<your_aws_secret_key>"
  region = "<your_aws_region>"
}

varialbe "hugo_site" {
    # your static site FQDN
    fqdn = "<www.yourwebsite.com>"
    # bucket prefix to make sure your s3 bucket names are globally unique, e.g. your aws account id.
    prefix = "<globally_unique_prefix>"
}