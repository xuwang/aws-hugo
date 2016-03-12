# Lambda function to call hugo

resource "aws_lambda_function" "hugo_lambda" {
    s3_bucket = "${aws_s3_bucket.lambda.id}"
    s3_key = "${aws_s3_bucket_object.lambda.id}"
    function_name = "hugo-lambda"
    role = "${aws_iam_role.lambda_role.arn}"
    handler = "RunHugo.handler"
    runtime = "nodejs"
    memory_size = 128
    timeout = 30

}

#output "hugo_lambda_arn" { value = "${aws_lambda_function.hugo_lambda.arn}" } // timeout problem.
output "hugo_lambda_name" { value = "${var.root_domain}-lambda"}

# Download hugo lambda function
resource "null_resource" "lambda_download" {
    triggers {
        lambda_function_tar_url = "${var.lambda_function_tar_url}"
    }

    provisioner "local-exec" {
        command = "des=artifacts/lambda.zip; if [ ! -f $des ]; then curl -s -o $des ${var.lambda_function_tar_url}; fi"
    }
}

# s3 bucket for lambda function
resource "aws_s3_bucket" "lambda" {
    bucket = "${var.root_domain}-lambda"
    force_destroy = true   force_destroy = true
    acl = "private"
    tags {
        Name = "${var.root_domain}-lambda"
    }
}

resource "aws_s3_bucket_object" "lambda" {
    bucket = "${aws_s3_bucket.lambda.id}"
    depends_on = ["null_resource.lambda_download"]
    key = "lambda"
    source = "artifacts/lambda.zip"
}
