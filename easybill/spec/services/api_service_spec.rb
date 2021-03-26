# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Easybill::ApiService do
  subject(:service) { described_class.new }

  let(:customer_id) { 1234 }
  let(:easybill_api_client) { instance_double(Easybill::Api::Client) }

  before do
    allow(ENV).to receive(:fetch).with('EASYBILL_API_KEY').and_return('easybill_api_key')
    allow(Easybill::Api::Client).to receive(:new) { easybill_api_client }
  end

  describe '#create_customer' do
    let(:customers_service) { double(:customers_service) }

    before do
      allow(customers_service).to receive(:create)
      allow(easybill_api_client).to receive(:customers) { customers_service }
    end

    it 'initializes an easybill api client' do
      service.create_customer({})

      expect(Easybill::Api::Client).to have_received(:new).with('easybill_api_key')
    end

    it 'loads the customers service' do
      service.create_customer({})

      expect(easybill_api_client).to have_received(:customers).with(no_args)
    end

    it 'calls create on the customer service' do
      service.create_customer('create_data')

      expect(customers_service).to have_received(:create).with('create_data')
    end
  end

  describe '#update_customer' do
    let(:customers_service) { double(:customers_service) }
    let(:easybill_customer_id) { 'external_id' }

    before do
      allow(customers_service).to receive(:update)
      allow(easybill_api_client).to receive(:customers) { customers_service }
    end

    it 'initializes an easybill api client' do
      service.update_customer(easybill_customer_id, {})

      expect(Easybill::Api::Client).to have_received(:new).with('easybill_api_key')
    end

    it 'loads the customers service' do
      service.update_customer(easybill_customer_id, {})

      expect(easybill_api_client).to have_received(:customers).with(no_args)
    end

    it 'calls update on the customer service' do
      service.update_customer(easybill_customer_id, 'update_data')

      expect(customers_service).to have_received(:update).with('external_id', 'update_data')
    end
  end

  describe '#create_document' do
    let(:documents_service) { double(:documents_service) }

    before do
      allow(easybill_api_client).to receive(:documents) { documents_service }
      allow(documents_service).to receive(:create)
    end

    it 'initializes an easybill api client' do
      service.create_document({})

      expect(Easybill::Api::Client).to have_received(:new).with('easybill_api_key')
    end

    it 'loads the documents service' do
      service.create_document({})

      expect(easybill_api_client).to have_received(:documents).with(no_args)
    end

    it 'calls create on the document service' do
      service.create_document('create_document_data')

      expect(documents_service).to have_received(:create).with('create_document_data')
    end
  end

  describe '#complete_document' do
    let(:documents_service) { double(:documents_service) }
    let(:document_id) { 'easybill-document-id' }

    before do
      allow(easybill_api_client).to receive(:documents) { documents_service }
      allow(documents_service).to receive(:done)
    end

    it 'initializes an easybill api client' do
      service.complete_document(document_id)

      expect(Easybill::Api::Client).to have_received(:new).with('easybill_api_key')
    end

    it 'loads the documents service' do
      service.complete_document(document_id)

      expect(easybill_api_client).to have_received(:documents).with(no_args)
    end

    it 'calls complete method on the document service' do
      service.complete_document(document_id)

      expect(documents_service).to have_received(:done).with('easybill-document-id')
    end
  end

  describe '#cancel_document' do
    let(:documents_service) { double(:documents_service) }
    let(:document_id) { 'easybill-document-id' }

    before do
      allow(easybill_api_client).to receive(:documents) { documents_service }
      allow(documents_service).to receive(:cancel)
    end

    it 'initializes an easybill api client' do
      service.cancel_document(document_id)

      expect(Easybill::Api::Client).to have_received(:new).with('easybill_api_key')
    end

    it 'loads the documents service' do
      service.cancel_document(document_id)

      expect(easybill_api_client).to have_received(:documents).with(no_args)
    end

    it 'calls cancel method on the document service' do
      service.cancel_document(document_id)

      expect(documents_service).to have_received(:cancel).with('easybill-document-id')
    end
  end

  describe '#create_position' do
    let(:positions_service) { double(:positions_service) }
    let(:position_data) { 'position_data' }

    before do
      allow(easybill_api_client).to receive(:positions) { positions_service }
      allow(positions_service).to receive(:create)
    end

    it 'initializes an easybill api client' do
      service.create_position(position_data)

      expect(Easybill::Api::Client).to have_received(:new).with('easybill_api_key')
    end

    it 'loads the documents service' do
      service.create_position(position_data)

      expect(easybill_api_client).to have_received(:positions).with(no_args)
    end

    it 'calls create method on the positions service' do
      service.create_position(position_data)

      expect(positions_service).to have_received(:create).with('position_data')
    end
  end

  describe '#update_position' do
    let(:positions_service) { double(:positions_service) }
    let(:position_data) { 'position_data' }
    let(:position_id) { 'position_id' }

    before do
      allow(easybill_api_client).to receive(:positions) { positions_service }
      allow(positions_service).to receive(:update)
    end

    it 'initializes an easybill api client' do
      service.update_position(position_id, position_data)

      expect(Easybill::Api::Client).to have_received(:new).with('easybill_api_key')
    end

    it 'loads the documents service' do
      service.update_position(position_id, position_data)

      expect(easybill_api_client).to have_received(:positions).with(no_args)
    end

    it 'calls update method on the positions service' do
      service.update_position(position_id, position_data)

      expect(positions_service).to have_received(:update).with('position_id', 'position_data')
    end
  end

  describe '#create_position_group' do
    let(:position_groups_service) { double(:positions_service) }
    let(:position_group_data) { 'position_group_data' }

    before do
      allow(easybill_api_client).to receive(:position_groups) { position_groups_service }
      allow(position_groups_service).to receive(:create)
    end

    it 'initializes an easybill api client' do
      service.create_position_group(position_group_data)

      expect(Easybill::Api::Client).to have_received(:new).with('easybill_api_key')
    end

    it 'loads the documents service' do
      service.create_position_group(position_group_data)

      expect(easybill_api_client).to have_received(:position_groups).with(no_args)
    end

    it 'calls cancel method on the document service' do
      service.create_position_group(position_group_data)

      expect(position_groups_service).to have_received(:create).with('position_group_data')
    end
  end

  describe '#find_position' do
    let(:positions_service) { double(:positions_service) }
    let(:resource_sku_handle) { 'a-resource-sku-handle' }
    let(:list_response) do
      {
        'items' => []
      }
    end

    before do
      allow(easybill_api_client).to receive(:positions) { positions_service }
      allow(positions_service).to receive(:list) { list_response }
    end

    it 'initializes an easybill api client' do
      service.find_position(resource_sku_handle)

      expect(Easybill::Api::Client).to have_received(:new).with('easybill_api_key')
    end

    it 'loads the positions service' do
      service.find_position(resource_sku_handle)

      expect(easybill_api_client).to have_received(:positions).with(no_args)
    end

    it 'calls the list method on the service' do
      service.find_position(resource_sku_handle)

      expect(positions_service).to have_received(:list).with(query: { handle: 'a-resource-sku-handle' })
    end
  end
end
