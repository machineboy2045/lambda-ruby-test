# frozen_string_literal: true

require 'spec_helper'
require './lambda_function'

RSpec.describe 'lambda_function' do
  before do
    DATABASE.clear
    DATABASE.migrate
  end

  describe 'users' do
    it 'creates' do
      lambda_handler(
        {
          event: {
            'resource' => '/users',
            'httpMethod' => 'POST',
            'queryStringParameters' => { 'name' => 'Billy Bob' }
          }
        }
      )

      response = lambda_handler(
        {
          event: {
            'resource' => '/users',
            'httpMethod' => 'GET'
          }
        }
      )

      expect(JSON.parse(response[:body]).first['name']).to eq('Billy Bob')
    end
  end
end
