# frozen_string_literal: true

require 'json'
require 'aws-record'
require 'securerandom'
require './config/database'
require './models/user'
require './lib/utils'

PROJECT_NAME = 'FulfillmentApi'
HTTP_HEADERS = { 'Access-Control-Allow-Origin' => '*' }.freeze
ENVS = {
  test: 'test',
  dev: 'dev',
  prod: 'prod'
}.freeze

def lambda_handler(event = {}, _context = {})
  resource = event.dig(:event, 'resource')
  http_method = event.dig(:event, 'httpMethod')
  params = event.dig(:event, 'queryStringParameters')
  stage = event.dig(:event, 'requestContext', 'stage') || ENVS[:dev]

  Utils.log({ resource: resource, http_method: http_method, params: params, stage: stage })

  { statusCode: 200, body: JSON.generate({ message: 'Hello world' }), headers: HTTP_HEADERS }

  # Database.new(stage)

  # case resource
  # when '/users'
  #   case http_method
  #   when 'POST'
  #     User.create(params)
  #   when 'GET'
  #     User.list
  #   end
  # end
end
