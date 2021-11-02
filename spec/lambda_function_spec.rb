require './lambda_function'

RSpec.describe "lambda_function" do

  it "has db" do
    expect(dynamo_client.list_tables.table_names).to eq(['users'])
  end

  it "runs" do
    migrate
    expect(lambda_handler.keys.sort).to eq([:body, :statusCode])
  end
end