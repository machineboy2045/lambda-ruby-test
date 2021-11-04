# frozen_string_literal: true

PROJECT_NAME = 'FulfillmentApi'
PROJECT_ENV = ENV['PROJECT_ENV']
TABLE_PREFIX = "#{PROJECT_NAME}-#{PROJECT_ENV}-"
HTTP_HEADERS = { 'Access-Control-Allow-Origin' => '*' }.freeze

require 'json'
require 'aws-record'
require 'securerandom'

require './config/database'
DATABASE = Database.new

require './models/user'
require './controllers/users_controller'
require './lib/utils'

def lambda_handler(event = {}, _context = {})
  resource = event.dig(:event, 'resource')
  http_method = event.dig(:event, 'httpMethod')
  params = event.dig(:event, 'queryStringParameters')

  Utils.log({ resource: resource, http_method: http_method, params: params })

  case resource
  when '/users'
    controller = UsersController.new
    case http_method
    when 'POST'
      controller.create(params)
    when 'GET'
      controller.index
    end
  end
end
