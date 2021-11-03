# frozen_string_literal: true
require 'json'
require 'aws-record'
require 'securerandom'

require './config/database'
$database = Database.new

require './models/user'
require './controllers/users_controller'
require './lib/utils'

def lambda_handler(event = {}, _context = {})
  resource = event.dig(:event, 'resource')
  http_method = event.dig(:event, 'httpMethod')
  params = event.dig(:event, 'queryStringParameters')

  Utils.log({ resource: resource, http_method: http_method, params: params })

  UsersController.call(http_method: http_method, params: params)
end
