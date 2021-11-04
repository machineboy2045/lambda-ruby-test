# frozen_string_literal: true

# Handles HTTP requests
class UsersController
  def create(params)
    result = User.new(id: SecureRandom.uuid, name: params['name']).save
    { statusCode: 200, body: JSON.generate(result), headers: HTTP_HEADERS }
  end

  def index
    result = User.scan
    items = result.page.map(&:to_h)
    { statusCode: 200, body: JSON.generate(items), headers: HTTP_HEADERS }
  end
end
