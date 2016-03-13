#!/usr/bin/env bash

# Terraform has yet to add this, but for now we have to use awscli to accomplish removing lambda s3 triggers
profile=myhugo
input_bucket_id=$(terraform output -module=hugo input_bucket_id)
hugo_lambda_name="$(terraform output -module=hugo hugo_lambda_name)"

aws --profile $profile lambda remove-permission --function-name $hugo_lambda_name \
    --statement-id AllowLambdaInvokeFunction
aws --profile $profile s3api put-bucket-notification-configuration \
        --bucket "$input_bucket_id" \
        --notification-configuration="{}"
