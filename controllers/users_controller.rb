class UsersController
  HEADERS = { 'Access-Control-Allow-Origin' => '*' }.freeze

  def self.call(event)
    new.call(event)
  end

  def call(http_method:, params: {})
    case http_method
    when 'POST'
      create(params)
    when 'GET'
      index
    end
  end

  private

  def create(params)
    result = User.new(id: SecureRandom.uuid, name: params['name']).save
    { statusCode: 200, body: JSON.generate(result), headers: HEADERS }
  end

  def index
    result = User.scan
    items = result.page.map(&:to_h)
    { statusCode: 200, body: JSON.generate(items), headers: HEADERS }
  end
end
