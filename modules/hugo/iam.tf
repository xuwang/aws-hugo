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

# Attach AWS managed policy
# Provides write permissions to CloudWatch Logs
resource "aws_iam_policy_attachment" "hugo_lambda_attach" {
    name = "${var.prefix}-lambda-policy-attachment"
    roles = ["${aws_iam_role.lambda_role.name}"]
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

    # sleep for awhile for the policy to be attaced.
    provisioner "local-exec" {
        command = "sleep 10"
    }
}

# Inline policy for permissions to access resources
resource "aws_iam_role_policy" "lambda_policy" {
    name = "${var.prefix}-lambda-role-policy"
    role = "${aws_iam_role.lambda_role.id}"
    policy = "${template_file.lambda_policy.rendered}"
}

# Prepare lambda role policy 
resource "template_file" "lambda_policy" {
    template = "${file("${var.lambda_role_policy_tmpl}")}"
    vars {
        "input_bucket_name" = "${aws_s3_bucket.input.id}"
        "html_bucket_name" = ${aws_s3_bucket.html.id}
    }
}



