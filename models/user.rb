# frozen_string_literal: true

class User
  include Aws::Record

  configure_client(client: DATABASE.client)
  set_table_name "#{TABLE_PREFIX}users"
  string_attr :id, hash_key: true
  string_attr :name

  def self.create(params)
    result = new(id: SecureRandom.uuid, name: params['name']).save
    { statusCode: 200, body: JSON.generate(result), headers: HTTP_HEADERS }
  end

  def self.list
    result = scan
    items = result.page.map(&:to_h)
    { statusCode: 200, body: JSON.generate(items), headers: HTTP_HEADERS }
  end
end
