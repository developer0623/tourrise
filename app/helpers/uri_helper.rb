# frozen_string_literal: true

module UriHelper
  def add_query_parameter_to_path(path, query_params)
    uri = Addressable::URI.parse(path)
    uri.query_values = uri.query_values.merge(query_params)
    uri.to_s
  end
end
