############################################################
#
# Set up source, static html, www, and logging bucket for a Hugo site
#

# bucket for hugo content source files
resource "aws_s3_bucket" "source" {
    bucket = "${var.bucket_prefix}-source"
    acl = "private"
    force_destroy = true

    versioning {
        enabled = true
    }

    logging {
        target_bucket = "${aws_s3_bucket.log.id}"
        target_prefix = "log/source/"
    }

    tags {
        Name = "${var.bucket_prefix}-source"
    }
}

# your static web site domain bucket
resource "aws_s3_bucket" "html" {
    bucket = "${var.bucket_prefix}.com"

    acl = "public-read"
    policy = "${template_file.html_policy.rendered}"

    website {
        index_document = "index.html"
        error_document = "error.html"
    }

    logging {
        target_bucket = "${aws_s3_bucket.log.id}"
        target_prefix = "log/html"
    }

    tags {
        Name = "${var.bucket_prefix}-www"
    }
}

# prepare static site bucket policy 
resource "template_file" "html_policy" {
    template = "${var.html_policy_tmpl}"
    vars {
        "bucket_name" = "${var.bucket_prefix}.com"
    }
}

# output the static html endpoint and domain
output "html_endpoint" {
    value = "${var.aws_s3_bucket.html.website_endpoint}"
}
output "html_domain" {
    value = "${var.aws_s3_bucket.html.website_domain}"
}

# your FQFD www bucket, that redirect to static html site
resource "aws_s3_bucket" "www" {
    bucket = "${var.www_fqdn}"

    website {
        redirect_all_requests_to = "${var.bucket_prefix}.com"
    }

    tags {
        Name = "${var.www_fqdn}"
    }
}

# output the www site endpoint and domain
output "web_endpoint" {
    value = "${var.aws_s3_bucket.www.website_endpoint}"
}
output "web_domain" {
    value = "${var.aws_s3_bucket.www.website_domain}"
}

# bucket for logging
resource "aws_s3_bucket" "log" {
   bucket = "${var.bucket_prefix}_log"
   acl = "log-delivery-write"
}

