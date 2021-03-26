module Seeds
  class Bookings
    def self.seed!
      pp "Seeding bookings"
      5.times do
        create_random_booking
      end

      create_at_booking_with_resources
    end

    def self.create_booking_with_product_and_resources(product_sku_id, resource_sku_ids)
      customer = Customer.all.sample
      starts_on = (Time.zone.now.to_date...(21.days.from_now)).to_a.sample
      ends_on = starts_on + (7...21).to_a.sample.days
      adults = rand(1..5)
      kids = rand(0..2)
      babies = 0

      context = ::Bookings::CreateBooking.call(
        params: {
          customer_id: customer.id,
          product_sku_id: product_sku_id,
          adults: adults,
          kids: kids,
          babies: babies,
          starts_on: starts_on,
          ends_on: ends_on
        },
        current_user: User.all.sample
      )

      booking = context.booking
      resource_sku_ids.each do |id|
        ::Bookings::CreateBookingResourceSku.call(
          booking: booking,
          resource_sku_id: id,
          params: {
            "booking_resource_sku" => {
              "starts_on" => booking.starts_on,
              "ends_on" => booking.ends_on
            }
          }
        )
      end
      initialize_participants_from_customers(booking, [customer, *Customer.where.not(id: customer.id).limit(adults + kids)])
      booking.save
    end

    def self.create_random_booking
      customer = Customer.all.sample
      starts_on = (Time.zone.now.to_date...(21.days.from_now)).to_a.sample
      ends_on = starts_on + (7...21).to_a.sample.days
      adults = rand(1..5)
      kids = rand(0..2)

      context = ::Bookings::CreateBooking.call(
        params: {
          customer_id: customer.id,
          product_sku_id: ProductSku.all.sample.id,
          starts_on: starts_on,
          ends_on: ends_on,
          adults: 0
        },
        current_user: User.all.sample
      )

      booking = context.booking
      initialize_participants_from_customers(booking, [customer, *Customer.where.not(id: customer.id).limit(adults + kids)])
      ResourceSku.all.sample(rand(0..8)).map do |sku|
        ::BookingResourceSkus::CreateBookingResourceSku.call(
          booking: booking,
          resource_sku_id: sku.id,
          params: {
            "booking_resource_sku" => {
              "starts_on" => booking.starts_on,
              "ends_on" => booking.ends_on
            }
          }
        )
      end
      booking.save
    end

    def self.create_at_booking_with_resources
      customer = Customer.last
      context = ::Bookings::CreateBooking.call!(
        params: {
          customer_id: customer.id,
          product_sku_id: ProductSku.all.sample.id,
          starts_on: 14.days.from_now,
          ends_on: 22.days.from_now,
        },
        current_user: User.last
      )

      booking = context.booking

      params = {
        "booking_resource_sku" => {
          "starts_on" => booking.starts_on,
          "ends_on" => booking.ends_on
        }
      }

      initialize_participants_from_customers(booking, [customer, *Customer.where.not(id: customer.id).limit(rand(0..5))])
      ::BookingResourceSkus::CreateBookingResourceSku.call!(
        booking_id: context.booking.id,
        resource_sku_id: ResourceSku.find_by(handle: 'camping-lt-550').id,
        params: params
      )

      ::BookingResourceSkus::CreateBookingResourceSku.call!(
        booking_id: context.booking.id,
        resource_sku_id: ResourceSku.find_by(handle: 'airport-transfer').id,
        params: params
      )

      booking.save
    end

    def self.initialize_participants_from_customers(booking, customers)
      customers.map do |customer|
        booking.participants.new(
          first_name: customer.first_name,
          last_name: customer.last_name,
          email: customer.email,
          birthdate: customer.birthdate
        )
      end
    end
  end
end
