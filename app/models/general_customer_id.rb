# frozen_string_literal: true

class GeneralCustomerId
  def self.next(customer)
    customer.id + 10_000
  end
end
