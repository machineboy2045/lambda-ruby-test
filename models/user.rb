# frozen_string_literal: true

class User
  include Aws::Record

  configure_client(client: DATABASE.client)
  set_table_name "#{TABLE_PREFIX}users"
  string_attr :id, hash_key: true
  string_attr :name
end
