require './lambda_function'

RSpec.describe 'lambda_function' do
  before do
    migrate
  end
  let(:event) do
    { event: { requestContext: { stage: 'test' } } }
  end
  let(:context) do
    {}
  end

  subject { lambda_handler(event, context) }

  it 'has db' do
    expect(db.list_tables.table_names).to eq(['users'])
  end

  it 'runs' do
    expect(subject.keys.sort).to eq([:body, :statusCode])
  end
end
