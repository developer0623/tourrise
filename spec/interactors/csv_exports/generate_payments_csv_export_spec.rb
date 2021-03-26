# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvExports::GeneratePaymentsCsvExport, type: :interactor do
  before do
    allow(CSV).to receive(:generate) { 'file.csv' }
  end

  it 'calls the interactor successfull' do
    context = described_class.call

    expect(context).to be_success
  end

  it 'generates a .csv file' do
    described_class.call

    expect(CSV).to have_received(:generate).with(headers: true, col_sep: ";")
  end

  it 'sends the .csv file' do
    context = described_class.call

    expect(context.csv).to eq('file.csv')
  end
end
