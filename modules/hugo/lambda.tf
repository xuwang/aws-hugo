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

# Download hugo lambda function
resource "null_resource" "lambda_download" {

    triggers {
        lambda_function_tar_url = "${var.lambda_function_tar_url}"
    }

    provisioner "local-exec" {
        command = "curl -s -o artifacts/${var.prefix}-lambda-function.zip ${var.lambda_function_tar_url}"
    }
}

# Not sure about event_source_arn is ok
resource "aws_lambda_event_source_mapping" "event_source_mapping" {
    event_source_arn = "${aws_lambda_function.hugo_labda.arn}"
    function_name = "${aws_lambda_function.hugo_labda.arn}"
    enabled = true
    starting_position = "TRIM_HORIZON|LATEST"
}