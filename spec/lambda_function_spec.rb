require './lambda_function'

RSpec.describe "lambda_function" do
  before do
    migrate
  end

  it "has db" do
    expect(db.list_tables.table_names).to eq(['users'])
  end

  it "runs" do
    expect(lambda_handler.keys.sort).to eq([:body, :statusCode])
  end
end
