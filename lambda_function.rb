# frozen_string_literal: true

require 'json'
require 'aws-record'

def db
  @db ||= if ENV['PROJECT_ENV'] == 'local'
            Aws::DynamoDB::Client.new(
              region: "local",
              endpoint: 'http://localhost:8001',
              access_key_id: "anykey-or-xxx",
              secret_access_key: "anykey-or-xxx"
            )
          else
            Aws::DynamoDB::Client.new
          end
end

class UsersTable
  include Aws::Record

  configure_client(client: db)
  set_table_name 'users'
  string_attr :id, hash_key: true
  string_attr :name
end

def migrate
  return if db.list_tables.table_names.include?('users')

  migration = Aws::Record::TableMigration.new(UsersTable, client: db)
  migration.create!(
    provisioned_throughput: {
      read_capacity_units: 5,
      write_capacity_units: 5
    }
  )
  migration.wait_until_available
end

def lambda_handler(_event = {}, _context = {})
  { statusCode: 200, body: JSON.generate(index) }
end

def create(id:, name:)
  UsersTable.new(id: id, name: name).save
end

def index
  result = UsersTable.scan
  result.page.map(&:to_h)
end
