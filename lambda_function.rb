# frozen_string_literal: true

require 'json'
require 'aws-record'
require 'securerandom'

class Db
  attr_reader :client

  def initialize
    @client = init_client
  end

  def clear
    Aws::Record::TableMigration.new(UsersTable, client: client).delete!
  rescue Aws::Record::Errors::TableDoesNotExist
  end

  def migrate
    migration = Aws::Record::TableMigration.new(UsersTable, client: client)
    migration.create!(
      provisioned_throughput: {
        read_capacity_units: 5,
        write_capacity_units: 5
      }
    )
    migration.wait_until_available
  end

  private

  def init_client
    if ENV['PROJECT_ENV'] == 'local'
      Aws::DynamoDB::Client.new(
        region: 'local',
        endpoint: 'http://localhost:8001',
        access_key_id: 'anykey-or-xxx',
        secret_access_key: 'anykey-or-xxx'
      )
    else
      Aws::DynamoDB::Client.new
    end
  end
end

$db = Db.new

class UsersTable
  include Aws::Record

  configure_client(client: $db.client)
  set_table_name 'users'
  string_attr :id, hash_key: true
  string_attr :name
end

class UsersController
  HEADERS = { 'Access-Control-Allow-Origin' => '*' }.freeze

  def create(params)
    result = UsersTable.new(id: SecureRandom.uuid, name: params['name']).save
    { statusCode: 200, body: JSON.generate(result), headers: HEADERS }
  end

  def index
    result = UsersTable.scan
    items = result.page.map(&:to_h)
    { statusCode: 200, body: JSON.generate(items), headers: HEADERS }
  end
end

def log(hash)
  puts JSON.generate(hash)
end

def lambda_handler(event = {}, _context = {})
  resource = event.dig(:event, 'resource')
  http_method = event.dig(:event, 'httpMethod')
  params = event.dig(:event, 'queryStringParameters')

  log({ resource: resource, http_method: http_method, params: params })

  controller = UsersController.new

  case http_method
  when 'POST'
    controller.create(params)
  when 'GET'
    controller.index
  end
end
