# Lambda function to call hugo

resource "aws_lambda_function" "hugo_lambda" {
    depends_on = ["null_resource.lambda_download"]
    filename = "artifacts/${var.prefix}-lambda-function.zip"
    function_name = "${var.prefix}-lambda"
    role = "${aws_iam_role.lambda_role.arn}"
    handler = "RunHugo.handler"
    runtime = "nodejs"
    memory_size = 128
    timeout = 30

}

#output "hugo_lambda_arn" { value = "${aws_lambda_function.hugo_lambda.arn}" } // timeout problem.
output "hugo_lambda_name" { value = "${var.prefix}-lambda"}

# Download hugo lambda function
resource "null_resource" "lambda_download" {
    triggers {
        lambda_function_tar_url = "${var.lambda_function_tar_url}"
    }

    provisioner "local-exec" {
        command = "des=artifacts/${var.prefix}-lambda-function.zip; if [ ! -f $des]; then curl -s -o $des ${var.lambda_function_tar_url}; fi"
    }
}

# Give s3 permistions to triger lambda
resource "aws_lambda_permission" "allow_s3" {
    statement_id = "${var.prefix}-allow-s3-trigger"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.hugo_lambda.arn}"
    principal = "s3.amazonaws.com"
    source_arn = "${aws_lambda_function.hugo_lambda.arn}"
}
