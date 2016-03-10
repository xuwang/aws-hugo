#!/usr/bin/env bash

# Terraform has yet to add this, but for now we have to use awscli to accomplish setting lambda s3 triggers

source_bucket_id=$(terraform output -module=hugo source_bucket_id)
hugo_lambda_arn=$(terraform output -module=hugo hugo_lambda_arn)
aws s3api put-bucket-notification-configuration \
        --bucket "$source_bucket_id" \
        --notification-configuration \
'{"LambdaFunctionConfigurations": [{"LambdaFunctionArn": "$hugo_lambda_arn", "Events": ["s3:ObjectCreated:*"], "Filter": {"Key": {"FilterRules": [{"Name": "prefix", "Value": "targets"}]}}}]}'

aws s3api put-bucket-notification-configuration \
        --bucket "$source_bucket_id" \
        --notification-configuration \
'{"LambdaFunctionConfigurations": [{"LambdaFunctionArn": "$hugo_lambda_arn", "Events": ["s3:Object Removed:*"], "Filter": {"Key": {"FilterRules": [{"Name": "prefix", "Value": "targets"}]}}}]}'
