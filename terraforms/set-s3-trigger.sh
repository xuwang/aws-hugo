#!/usr/bin/env bash

# Terraform has yet to add this, but for now we have to use awscli to accomplish setting lambda s3 triggers

input_bucket_id=$(terraform output -module=hugo input_bucket_id)
hugo_lambda_name="$(terraform output -module=hugo hugo_lambda_name)"
hugo_lambda_arn=$(aws --profile myhugo lambda  list-functions \
    | jq -r ".Functions | .[] | select(.FunctionName==\"$hugo_lambda_name\") \
    | .FunctionArn")

read -r -d '' EVENT << EOF
{
    "LambdaFunctionConfigurations": [{
        "LambdaFunctionArn": "$hugo_lambda_arn",
        "Events": [
            "s3:ObjectRemoved:*",
            "s3:ObjectCreated:*"
        ]
    }]
}
EOF
aws --profile myhugo s3api put-bucket-notification-configuration \
        --bucket "$input_bucket_id" \
        --notification-configuration "$EVENT"
