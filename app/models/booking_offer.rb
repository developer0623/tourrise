# frozen_string_literal: true

class BookingOffer < BookingDocument
  has_paper_trail ignore: %i[created_at updated_at]
end
