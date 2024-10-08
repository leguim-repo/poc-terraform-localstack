# Cheatsheet with awslocal commands to play with localstack

## S3

~~~bash
awslocal s3api get-bucket-location --bucket pre-snowflake-raw-pepe-integration

echo "\nBuckets and region associated:"
for bucket in `awslocal s3api list-buckets --query "Buckets[].Name" --output text`; do
    location=`awslocal s3api get-bucket-location --bucket $bucket --output text`
    echo "Bucket: $bucket - Region: $location"
done

~~~

## IAM

~~~bash
awslocal iam list-roles
awslocal iam list-policies
~~~

## SNS

~~~bash
awslocal sns list-topics
awslocal sns publish --topic-arn  "arn:aws:sns:eu-central-1:000000000000:sns-reception-topic-ftm-test" --subject "[RAMMSTEIN]" --message "testing sns from asw cli"
~~~

## Lambda

~~~bash
awslocal lambda list-functions
awslocal lambda invoke --function-name lambda_sns_publisher --payload '{ "name": "Bob" }' invoke_response.json ; cat invoke_response.json
awslocal lambda invoke --function-name lambda_sns_subscriber --payload '{ "name": "Bob" }' invoke_response.json ; cat invoke_response.json
awslocal lambda invoke --function-name lambda_dummy-ftm-test invoke_response.json ; cat invoke_response.json  | jq .
~~~

## Cloudwatch & Logs

~~~bash
awslocal cloudwatch list-metrics
awslocal logs describe-log-groups
awslocal logs describe-log-groups --query "logGroups[*].logGroupName"
awslocal logs describe-log-streams --log-group-name "/aws/lambda/lambda_sns_publisher"
awslocal logs describe-log-streams --log-group-name "/aws/lambda/lambda_sns_subscriber"
awslocal logs describe-log-streams --log-group-name "/aws/lambda/lambda_dummy"
awslocal logs describe-log-streams --log-group-name "/aws/lambda/lambda_intake-ftm-test"
awslocal logs describe-log-streams --log-group-name "sns/us-east-1/000000000000/sns-reception-topic-ftm-test"

awslocal logs get-log-events --log-group-name "/aws/lambda/lambda_sns_publisher" --log-stream-name "2022/05/28/[LATEST]29201819"
awslocal logs get-log-events --log-group-name "/aws/lambda/lambda_sns_subscriber" --log-stream-name "2022/06/05/[LATEST]c0b51df1"
awslocal logs get-log-events --log-group-name "/aws/lambda/lambda_dummy" --log-stream-name "2022/06/04/[LATEST]9575fbcc"
awslocal logs get-log-events --log-group-name "/aws/lambda/lambda_intake-ftm-test" --log-stream-name "2022/06/19/[LATEST]0c88678d"
awslocal logs get-log-events --log-group-name "sns/us-east-1/000000000000/sns-reception-topic-ftm-test" --log-stream-name "b58d487f-c835-4d43-bc7e-9a6b6f6aab68"
~~~

## Cloudformation

~~~bash
awslocal cloudformation list-stacks
~~~

## S3

~~~bash
awslocal s3api get-bucket-notification-configuration --bucket s3-event-to-sns
awslocal s3api get-bucket-policy --bucket s3-event-to-sns
awslocal s3api get-bucket-policy-status --bucket s3-event-to-sns

awslocal s3 cp requirements.txt s3://s3-event-to-sns/requirements.txt
awslocal s3 cp unicorn.jpeg s3://s3-intake-fundaciontonymanero-test/pictures/unicorn.jpeg
~~~

## Parameters Store

~~~bash
awslocal ssm describe-parameters
awslocal ssm get-parameter --name /ftm/intake_bucket_name
awslocal ssm get-parameter --name /ftm/consum_bucket_name | jq
awslocal ssm get-parameter --name /ftm/consum_bucket_name | jq '.Parameter.Value'
awslocal ssm get-parameter --name /ftm/consum_bucket_name | jq '.Parameter.ARN'
~~~

## EventBridge

~~~bash
awslocal events list-event-buses
awslocal events describe-event-bus
awslocal events list-rules | jq
~~~

## Kms

~~~bash
awslocal kms list-keys
~~~

## DynamoDb

~~~bash
awslocal dynamodb list-tables
awslocal dynamodb describe-global-table
~~~

## VPC

~~~bash
awslocal ec2 describe-vpcs
awslocal ec2 describe-vpc-endpoints
awslocal ec2 describe-vpc-endpoint-services
awslocal ec2 describe-security-groups
~~~

## Secrets Manager

~~~bash
awslocal secretsmanager list-secrets
awslocal secretsmanager get-secret-value --secret-id my.secrets | jq -r '.SecretString'
awslocal secretsmanager update-secret --secret-id my_secret_name --secret-string file://dpp-secret.json
~~~
