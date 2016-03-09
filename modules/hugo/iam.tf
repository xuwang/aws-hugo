# Setup a role and role policy for lambda

resource "aws_iam_role" "lambda_role" {
    name = "${var.prefix}-lambda-role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "hugo_lambda_attach" {
    name = "${var.prefix}-lambda-policy-attachment"
    roles = ["${aws_iam_role.lambda_role.name}"]
    policy_arn = "${aws_iam_policy.lambda_policy.arn}"
}

resource "aws_iam_role_policy" "lambda_policy" {
    name = "${var.prefix}-lambda-role-policy"
    role = "${aws_iam_role.lambda_role.id}"
    policy = "${template_file.lamba_policy.rendered}"
}

# prepare lambda role policy 
resource "template_file" "lamba_policy" {
    template = "${var.lambda_role_policy_tmpl}"
    vars {
        "source_bucket_name" = "${var.prefix}-source"
        "html_bucket_name" = "${var.prefix}-html.com"
    }
}



