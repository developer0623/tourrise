# frozen_string_literal: true

module Easybill
  class ApiService
    def initialize(api_key: nil)
      @api_key = api_key || default_api_key
    end

    def create_customer(customer_data)
      client.customers.create(customer_data)
    end

    def update_customer(customer_id, customer_data)
      client.customers.update(customer_id, customer_data)
    end

    def create_document(document_data)
      client.documents.create(document_data)
    end

    def cancel_document(document_id)
      client.documents.cancel(document_id)
    end

    def complete_document(document_id)
      client.documents.done(document_id)
    end

    def download_document(document_id)
      client.documents.pdf(document_id)
    end

    def create_position(position_data)
      client.positions.create(position_data)
    end

    def update_position(position_id, position_data)
      client.positions.update(position_id, position_data)
    end

    def create_position_group(position_group_data)
      client.position_groups.create(position_group_data)
    end

    def find_position(handle)
      client.positions.list(query: { handle: handle })["items"].first
    end

    def find_document(document_id)
      client.documents.find(document_id)
    end

    private

    def client
      @client ||= ::Easybill::Api::Client.new(@api_key)
    end

    def default_api_key
      ENV.fetch("EASYBILL_API_KEY")
    end
  end
end
