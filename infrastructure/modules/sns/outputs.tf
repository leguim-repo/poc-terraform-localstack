output "lambda_sns_subscriber_arn" {
  value = aws_sns_topic.lambda_sns_subscriber.arn
}

output "sns_topic_arn" {
  value = aws_sns_topic_subscription.invoke_with_sns.topic_arn
}
