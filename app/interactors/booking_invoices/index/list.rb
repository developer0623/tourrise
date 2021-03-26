# frozen_string_literal: true

module BookingInvoices
  module Index
    class List
      include Interactor::Organizer

      organize Load, Filter, Paginate
    end
  end
end
