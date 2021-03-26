# frozen_string_literal: true

class BookingInvoice < BookingDocument
  has_paper_trail ignore: %i[created_at updated_at]

  has_many :payments

  accepts_nested_attributes_for :payments
end
