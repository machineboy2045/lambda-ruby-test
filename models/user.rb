class User
  include Aws::Record

  configure_client(client: $database.client)
  set_table_name 'users'
  string_attr :id, hash_key: true
  string_attr :name
end
