require 'json'
require 'active_support'
require 'aws-sdk-dynamodb'

def lambda_handler(event:, context:)
  dynamodb_client = Aws::DynamoDB::Client.new(region: 'us-east-2')
  result = dynamodb_client.scan(table_name: 'users')

  { statusCode: 200, body: JSON.generate(result.items) }
end
