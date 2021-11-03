# lambda-ruby-test
https://gzzn1dr3wf.execute-api.us-east-2.amazonaws.com/test/users

```bash
# Open console
PROJECT_ENV=local bundle exec irb -r ./lambda_function.rb

# Run tests
docker-compose up -d
PROJECT_ENV=local bundle exec rspec

# curl examples
curl -X GET "https://gzzn1dr3wf.execute-api.us-east-2.amazonaws.com/production/users"
curl -X POST -H "x-api-key: YOUR_API_KEY" "https://gzzn1dr3wf.execute-api.us-east-2.amazonaws.com/production/users?name=Alice"

```
