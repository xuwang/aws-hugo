############################################################
#
# Set up input, static html, www, and logging bucket for a Hugo site
#

# The static web site bucket, i.e. hugo lambda function destination bucket
resource "aws_s3_bucket" "html" {
    bucket = "${var.root_domain}"
    force_destroy = true

    acl = "public-read"
    policy = "${template_file.html_policy.rendered}"

    website {
        index_document = "index.html"
        error_document = "404.html"
    }

    logging {
        target_bucket = "${aws_s3_bucket.log.id}"
        target_prefix = "log/${var.root_domain}/"
    }

    tags {
        Name = "${var.root_domain}"
    }
}

# prepare static site bucket policy 
resource "template_file" "html_policy" {
    template = "${file("${var.html_policy_tmpl}")}"
    vars {
        "bucket_name" = "${var.root_domain}"
    }
}

# output the static html endpoint and domain
output "html_endpoint" {
    value = "${aws_s3_bucket.html.website_endpoint}"
}
output "html_domain" {
    value = "${aws_s3_bucket.html.website_domain}"
}
output "html_bucket_id" {
    value = "${aws_s3_bucket.html.id}"
}


# Bucket for hugo content input files, i.e. the hugo lambda source bucket
# Note the input bucket name must be "input.<static_html_bucket_name>"
# otherwise the lambda code won't be able to find destination bucket
resource "aws_s3_bucket" "input" {
    bucket = "input.${aws_s3_bucket.html.id}"
    acl = "private"
    force_destroy = true

    versioning {
        enabled = true
    }

    logging {
        target_bucket = "${aws_s3_bucket.log.id}"
        target_root_domain = "log/input.${aws_s3_bucket.html.id}/"
    }

    tags {
        Name = "input.${aws_s3_bucket.html.id}"
    }
}

output "input_bucket_id" {
    value = "${aws_s3_bucket.input.id}"
}

# your FQFD www bucket, that redirect to static html site
resource "aws_s3_bucket" "www" {

    bucket = "www.${var.root_domain}"
    force_destroy = true

    website {
        redirect_all_requests_to = "${aws_s3_bucket.html.website_endpoint}"
    }

    tags {
        Name = "www.${var.root_domain}"
    }
}

# output the www site endpoint and domain
output "www_endpoint" {
    value = "${aws_s3_bucket.www.website_endpoint}"
}
output "www_domain" {
    value = "${aws_s3_bucket.www.website_domain}"
}
output "www_bucket_id" {
    value = "${aws_s3_bucket.www.id}"
}

# bucket for logging
    bucket = "${var.root_domain}-log"
    acl = "log-delivery-write"
    force_destroy = true
}


