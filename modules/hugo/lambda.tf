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

output "hugo_lambda_arn" { value = "${aws_lambda_function.hugo_lambda.arn}" }

# Download hugo lambda function
resource "null_resource" "lambda_download" {

    triggers {
        lambda_function_tar_url = "${var.lambda_function_tar_url}"
    }

    provisioner "local-exec" {
        command = "curl -s -o artifacts/${var.prefix}-lambda-function.zip ${var.lambda_function_tar_url}"
    }
}

# subscribe github updates
resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
    topic_arn = "${aws_sns_topic.user_updates.arn}"
    protocol  = "lambda"
    endpoint  = "${aws_lambda_function.hugo_lambda.arn}"
}