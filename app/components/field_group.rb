# frozen_string_literal: true

class FieldGroup < ViewComponent::Base
  def initialize(columns: 3)
    @columns = columns
  end
end
