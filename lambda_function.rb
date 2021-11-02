require 'json'
require 'aws-record'

class UsersTable
  include Aws::Record
  set_table_name 'users'
  string_attr :id, hash_key: true
  string_attr :name
end

def lambda_handler(event:, context:)
  result = UsersTable.scan
  items = result.page.map(&:to_h)

  { statusCode: 200, body: JSON.generate(items) }
end
