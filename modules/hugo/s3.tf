############################################################
#
# Set up source, static html, www, and logging bucket for a Hugo site
#

# bucket for hugo content source files
resource "aws_s3_bucket" "source" {
    bucket = "${var.prefix}-source"
    acl = "private"
    force_destroy = true

    versioning {
        enabled = true
    }

    logging {
        target_bucket = "${aws_s3_bucket.log.id}"
        target_prefix = "log/${var.prefix}-source/"
    }

    tags {
        Name = "${var.prefix}-source"
    }
}

output "source_bucket_id" {
    value = "${aws_s3_bucket.source.id}"
}

# your static web site domain bucket
resource "aws_s3_bucket" "html" {
    bucket = "${var.prefix}-html.com"

    acl = "public-read"
    policy = "${template_file.html_policy.rendered}"

    website {
        index_document = "index.html"
        error_document = "404.html"
    }

    logging {
        target_bucket = "${aws_s3_bucket.log.id}"
        target_prefix = "log/${var.prefix}-html/"
    }

    tags {
        Name = "${var.prefix}-html.com"
    }
}

# prepare static site bucket policy 
resource "template_file" "html_policy" {
    template = "${file("${var.html_policy_tmpl}")}"
    vars {
        "bucket_name" = "${var.prefix}-html.com"
    }
}

# output the static html endpoint and domain
output "html_endpoint" {
    value = "${aws_s3_bucket.html.website_endpoint}"
}
output "html_domain" {
    value = "${aws_s3_bucket.html.website_domain}"
}

# your FQFD www bucket, that redirect to static html site
resource "aws_s3_bucket" "www" {
    bucket = "${var.www_fqdn}"

    website {
        redirect_all_requests_to = "${var.prefix}-html.com"
    }

    tags {
        Name = "${var.www_fqdn}"
    }
}

# output the www site endpoint and domain
output "web_endpoint" {
    value = "${aws_s3_bucket.www.website_endpoint}"
}
output "web_domain" {
    value = "${aws_s3_bucket.www.website_domain}"
}

# bucket for logging
resource "aws_s3_bucket" "log" {
   bucket = "${var.prefix}-log"
   acl = "log-delivery-write"
}

