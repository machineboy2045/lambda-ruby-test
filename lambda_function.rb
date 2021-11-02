require 'json'
require 'aws-sdk-dynamodb'

def get_table_names(dynamodb_client)
  result = dynamodb_client.list_tables
  result.table_names
rescue StandardError => e
  puts "Error getting table names: #{e.message}"
  'Error'
end

def lambda_handler(event:, context:)
  region = 'us-east-2'
  dynamodb_client = Aws::DynamoDB::Client.new(region: region)
  result = dynamodb_client.scan(table_name: 'http-crud-tutorial-items')

  { statusCode: 200, body: { items: result.items } }
end
