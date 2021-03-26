# frozen_string_literal: true

RSpec.shared_examples 'a standard show action' do |load_command_class, result_factory|
  let(:load_command_class) { load_command_class }
  let(:result) { create(result_factory) }
  let(:show_params) { { id: result.id } }

  before do
    command = instance_double(load_command_class)
    allow(load_command_class).to receive(:call).and_return(command)
    allow(command).to receive(:success?).and_return(true)
    allow(command).to receive(:result).and_return(result)
  end

  it 'responds with json' do
    get :show, params: show_params

    headers = response.headers
    expect(headers['Content-Type']).to include('application/json')
  end

  it 'calls the load command' do
    get :show, params: show_params

    expect(load_command_class).to have_received(:call)
  end
end
