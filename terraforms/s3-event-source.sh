#!/bin/evn bash

# Terraform has yet to add this, but for now we have to use awscli to accomplish setting lambda s3 triggers


aws s3api put-bucket-notification-configuration \
        --bucket "`terraform output input_bucket_id`" \
        --notification-configuration \
'{"LambdaFunctionConfigurations": [{"LambdaFunctionArn": "'`terraform output hugo_lambda_arn`'", "Events": ["s3:ObjectCreated:*"], "Filter": {"Key": {"FilterRules": [{"Name": "prefix", "Value": "targets"}]}}}]}'

aws s3api put-bucket-notification-configuration \
        --bucket "`terraform output input_bucket_id`" \
        --notification-configuration \
'{"LambdaFunctionConfigurations": [{"LambdaFunctionArn": "'`terraform output hugo_lambda_arn`'", "Events": ["s3:Object Removed:*"], "Filter": {"Key": {"FilterRules": [{"Name": "prefix", "Value": "targets"}]}}}]}'