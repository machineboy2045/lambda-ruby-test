# lambda-ruby-test
https://gzzn1dr3wf.execute-api.us-east-2.amazonaws.com/prod/users

```bash
# Start local dynamodb
docker-compose up -d

# Open console
bundle exec irb -r ./lambda_function.rb

# Run tests
bundle exec rspec

# Validate Cloudformation template
aws cloudformation validate-template --template-body file://cloudformation_template.yml

# Production curl examples
curl -X GET "https://gzzn1dr3wf.execute-api.us-east-2.amazonaws.com/production/users"
curl -X POST -H "x-api-key: YOUR_API_KEY" "https://gzzn1dr3wf.execute-api.us-east-2.amazonaws.com/production/users?name=Alice"

```
