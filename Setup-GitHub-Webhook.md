## Setup the GitHub Webhook
1. Navigate to your [GitHub](https://github.com) repo.

1. Click on “Settings” in the sidebar.

1. Click on “Webhooks & Services”.

1. Click the “Add service” dropdown, then click “AmazonSNS”.

1. Fill out the form with values from:

	```
	aws_region = `terraform output region`	sns_topic = `terraform output module.hugo.hugo_sns_topic_arn`
	aws_key = `terraform output module.hugo.hogo_user_access_secret`
	aws_secret = `terraform output module.hugo.hogo_user_access_key`
	```

1. “Add service”.