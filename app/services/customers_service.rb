# frozen_string_literal: true

class CustomersService
  SEPARATOR = Arel::Nodes.build_quoted(" ")

  attr_reader :customers

  def initialize(customers)
    @customers = customers
  end

  def search(search_term)
    return customers if search_term.blank?

    concat = Arel::Nodes::NamedFunction.new("concat", [customers_table[:first_name], SEPARATOR, customers_table[:last_name]])

    customers.where(concat.matches("%#{search_term}%"))
  end

  private

  def customers_table
    @customers_table ||= Customer.arel_table
  end
end
