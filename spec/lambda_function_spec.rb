require './lambda_function'

RSpec.describe "lambda_function" do
  it "runs" do
    migrate
    expect(lambda_handler.keys.sort).to eq([:body, :statusCode])
  end
end