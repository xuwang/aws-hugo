# hugo user for sns update etc.
resource "aws_iam_user" "hugo_user" {
    name = "${var.prefix}-hugo-user}"
    path = "/service-account/"
}

resource "aws_iam_user_policy" "hugo_user" {
    name = "${aws_iam_user.hugo_user.name}-policy}"
    user = "${aws_iam_user.hugo_user.name}"
    policy = "${template_file.user_policy.rendered}"
}

resource "template_file" "user_policy" {
    template = "${file("${var.hugo_user_policy_tmpl}")}"
    vars {
        "sns_topic_arn" = "${aws_sns_topic.user_updates.arn}"
    }
}

resource "aws_iam_access_key" "hugo_user_key" {
    user = "${aws_iam_user.hugo_user.name}"
}

# hugo_user  - The IAM user associated with this access key.
output "hogo_user" {
    value = "${aws_iam_user.hugo_user.name}"
}
# hogo_user_access_key - The access key ID.
output "hogo_user_access_key" {
    value = "${aws_iam_access_key.aws_iam_access_key.hugo_user.id}"
}
# hogo_user_access_secret - The secret access key.
output "hogo_user_access_secret" {
    value = "${aws_iam_access_key.aws_iam_access_key.hugo_user.secret}"
}

# Setup a role and role policy for lambda
resource "aws_iam_role" "lambda_role" {
    name = "${var.root_domain}-lambda-role"
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

# Attach AWS managed policy
# Provides write permissions to CloudWatch Logs
resource "aws_iam_policy_attachment" "hugo_lambda_attach" {
    name = "${var.root_domain}-lambda-policy-attachment"
    roles = ["${aws_iam_role.lambda_role.name}"]
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Inline policy for permissions to access resources
resource "aws_iam_role_policy" "lambda_policy" {
    name = "${var.root_domain}-lambda-role-policy"
    role = "${aws_iam_role.lambda_role.id}"
    policy = "${template_file.lambda_policy.rendered}"
}
