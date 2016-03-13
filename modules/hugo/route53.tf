# If root domain is already exist on AWS route 53, comment out aws_route53_zone resource, replace zone_id
# in the route53_record with the partent domain zone id.
#
#
resource "aws_route53_zone" "main" {
  name = "${var.root_domain}"
}

resource "aws_route53_record" "root_domain" {
    zone_id = "${aws_route53_zone.main.id}"
    name = "${var.root_domain}"
    type = "A"
    alias {
      name = "${aws_s3_bucket.html.website_domain}"
      zone_id = "${aws_s3_bucket.html.hosted_zone_id}"
      evaluate_target_health = true
    }
    
}