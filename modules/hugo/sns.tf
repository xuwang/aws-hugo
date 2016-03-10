resource "aws_sns_topic" "user_updates" {
  name = "${var.prefix}-updates-topic"
}

output "hugo_sns_topic_arn" {
    value = "${aws_sns_topic.user_updates.arn}"
}