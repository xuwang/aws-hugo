#!/usr/bin/env bash

# Terraform has yet to add this, but for now we have to use awscli to accomplish removing lambda s3 triggers
input_bucket_id=$(terraform output -module=hugo input_bucket_id)

aws --profile myhugo s3api put-bucket-notification-configuration \
        --bucket "$input_bucket_id" \
        --notification-configuration="{}"
