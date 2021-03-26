# frozen_string_literal: true

RSpec.shared_examples 'a standard index action' do |list_command_class, custom_params|
  let(:list_command_class) { list_command_class }

  before do
    context = instance_double(list_command_class)
    allow(list_command_class).to receive(:call).and_return(context)
    allow(context).to receive(:success?).and_return(true)
    allow(context).to receive(:result).and_return([])
  end

  it 'calls the list command' do
    get :index, params: custom_params ? public_send(custom_params) : {}

    expect(list_command_class).to have_received(:call)
  end

  it 'returns a collection' do
    get :index, params: custom_params ? public_send(custom_params) : {}

    expect(json['collection']).to eq([])
  end

  def json
    @json ||= JSON.parse(response.body)
  end
end
