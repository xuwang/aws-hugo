# Lambda function to call hugo

resource "aws_lambda_function" "hugo_lambda" {
    depends_on = ["template_file.lambda_download"]
    filename = "artifacts/${prefix}-lambda-function.zip"
    function_name = "${prefix}-lambda"
    role = "${aws_iam_role.lambda_role.arn}"
    handler = "RunHugo.handler"
    runtime = "nodejs"
    memory_size = 128
    timeout = 30
}

# Download hugo lambda function
resource "template_file" "lambda_download" {
    template = "/dev/null"

    provisioner "local-exec" {
        command = "curl -s -o artifacts/${prefix}-lambda-function.zip ${var.lambda_function_tar_url}"
    }
}
