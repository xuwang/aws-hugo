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

    # Set up lambda s3 triggers. 
    # Terraform has yet to add this, but for now we have to use awscli to accomplish it
    provisioner "local-exec" {
        command = <<EOT
aws s3api put-bucket-notification-configuration \
    --bucket "${aws_s3_bucket.input.id}" \
    --notification-configuration \
'{"LambdaFunctionConfigurations": [{"LambdaFunctionArn": "${aws_lambda_function.hugo_lambda.arn}", "Events": ["s3:ObjectCreated:*"], "Filter": {"Key": {"FilterRules": [{"Name": "prefix", "Value": "targets"}]}}}]}'

aws s3api put-bucket-notification-configuration \
    --bucket "${aws_s3_bucket.input.id}" \
    --notification-configuration \
'{"LambdaFunctionConfigurations": [{"LambdaFunctionArn": "${aws_lambda_function.hugo_lambda.arn}", "Events": ["s3:Object Removed:*"], "Filter": {"Key": {"FilterRules": [{"Name": "prefix", "Value": "targets"}]}}}]}'
EOT
    }

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

# Give s3 permistions to triger lambda
resource "aws_lambda_permission" "allow_s3" {
    statement_id = "${var.prefix}-allow-s3-trigger"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.hugo_lambda.arn}"
    principal = "s3.amazonaws.com"
    source_arn = "${aws_lambda_function.hugo_lambda.arn}"
}
