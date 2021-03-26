# frozen_string_literal: true

module JsonRequestHelper
  def json_headers
    {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
  end

  def json
    JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include JsonRequestHelper, type: :rest_controller

  config.before(:each, type: :rest_controller) do
    request.headers.merge!(json_headers)
  end
end
