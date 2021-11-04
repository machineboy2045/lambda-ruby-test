# frozen_string_literal: true

class Database
  attr_reader :client

  def initialize
    @client = init_client
  end

  def clear
    Aws::Record::TableMigration.new(User, client: client).delete!
  rescue Aws::Record::Errors::TableDoesNotExist
    false
  end

  def migrate
    migration = Aws::Record::TableMigration.new(User, client: client)
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
    if PROJECT_ENV =~ /test|development/
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
