# hugo user for sns update etc.
resource "aws_iam_user" "hugo_user" {
    name = "${var.prefix}-hugo-user}"
    path = "/service-account/"
}

resource "aws_iam_user_policy" "hugo_user" {
    name = "${aws_iam_user.hugo_user.name}-policy}"
    user = "${aws_iam_user.hugo_user.name}"
    policy = "${template_file.user_policy.rended}"
}

resource "template_file" "user_policy" {
    template = "${file("${var.hugo_user_policy_tmpl}")}"
    vars {
        "sns_topic_arn" = "${aws_sns_topic.user_updates.arn}"
    }
}

resource "aws_iam_access_key" "hugo_user_key" {
    user = "${aws_iam_user.hugo_user.name}"
}

# hugo_user  - The IAM user associated with this access key.
output "hogo_user" {
    value = "${aws_iam_user.hugo_user.name}"
}
# hogo_user_access_key - The access key ID.
output "hogo_user_access_key" {
    value = "${aws_iam_access_key.aws_iam_access_key.hugo_user.id}"
}
# hogo_user_access_secret - The secret access key.
output "hogo_user_access_secret" {
    value = "${aws_iam_access_key.aws_iam_access_key.hugo_user.secret}"
}