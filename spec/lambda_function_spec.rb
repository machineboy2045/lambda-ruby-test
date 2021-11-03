require './lambda_function'

RSpec.describe 'lambda_function' do
  before do
    $db.clear
    $db.migrate
  end

  describe 'users' do
    it 'creates' do
      lambda_handler({
        event: {
          'resource' => '/users',
          'httpMethod' => 'POST',
          'queryStringParameters' => { 'name' => 'Will' }
        }
      })

      response = lambda_handler({
        event: {
          'resource' => '/users',
          'httpMethod' => 'GET'
        }
      })

      expect(JSON.parse(response[:body]).first['name']).to eq('Will')
    end
  end
end
