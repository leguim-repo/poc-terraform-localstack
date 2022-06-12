awslocal iam list-roles
awslocal iam list-policies


awslocal sns list-topics
awslocal sns publish --topic-arn  "arn:aws:sns:us-east-1:000000000000:sns-reception-topic-fundaciontonymanero-test" --subject "[RAMMSTEIN]" --message "testing sns from asw cli"

awslocal lambda list-functions
awslocal lambda invoke --function-name lambda_sns_publisher --payload '{ "name": "Bob" }' invoke_response.json ; cat invoke_response.json
awslocal lambda invoke --function-name lambda_sns_subscriber --payload '{ "name": "Bob" }' invoke_response.json ; cat invoke_response.json
awslocal lambda invoke --function-name lambda_dummy invoke_response.json ; cat invoke_response.json

awslocal cloudwatch list-metrics
awslocal logs describe-log-groups
awslocal logs describe-log-groups --query "logGroups[*].logGroupName"
awslocal logs describe-log-streams --log-group-name "/aws/lambda/lambda_sns_publisher"
awslocal logs describe-log-streams --log-group-name "/aws/lambda/lambda_sns_subscriber"
awslocal logs describe-log-streams --log-group-name "/aws/lambda/lambda_dummy"
awslocal logs describe-log-streams --log-group-name "/aws/lambda/lambda_intake"

awslocal logs get-log-events --log-group-name "/aws/lambda/lambda_sns_publisher" --log-stream-name "2022/05/28/[LATEST]29201819"
awslocal logs get-log-events --log-group-name "/aws/lambda/lambda_sns_subscriber" --log-stream-name "2022/06/05/[LATEST]c0b51df1"
awslocal logs get-log-events --log-group-name "/aws/lambda/lambda_dummy" --log-stream-name "2022/06/04/[LATEST]9575fbcc"
awslocal logs get-log-events --log-group-name "/aws/lambda/lambda_intake" --log-stream-name "2022/06/05/[LATEST]301d24ba"


awslocal cloudformation list-stacks

awslocal s3api get-bucket-notification-configuration --bucket s3-event-to-sns
awslocal s3api get-bucket-policy --bucket s3-event-to-sns
awslocal s3api get-bucket-policy-status --bucket s3-event-to-sns

awslocal s3 cp requirements.txt s3://s3-event-to-sns/requirements.txt
awslocal s3 cp unicorn.jpeg s3://s3-intake-fundaciontonymanero-test/pictures/unicorn.jpeg