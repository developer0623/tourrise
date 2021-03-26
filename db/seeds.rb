# frozen_string_literal: true

require_relative './seeds/users'
require_relative './seeds/customers'
require_relative './seeds/resource_types'
require_relative './seeds/frontoffice_steps'
require_relative './seeds/products'
require_relative './seeds/bookings'
require_relative './seeds/resources'
require_relative './seeds/camp_fuerteventura'
require_relative './seeds/occupation_configurations'
require_relative './seeds/hawaii'
require_relative './seeds/flights'
require_relative './seeds/accountings'
require_relative './seeds/seasons'

Faker::Config.locale = :de

Seeds::Users.seed!
Seeds::Customers.seed!
Seeds::ResourceTypes.seed!
Seeds::Accountings.seed!
Seeds::OccupationConfigurations.seed!
Seeds::FrontofficeSteps.seed!
Seeds::Resources.seed!
Seeds::Products.seed!
Seeds::Hawaii.seed!
Seeds::Bookings.seed!
Seeds::CampFuerteventura.seed!
Seeds::Flights.seed!
Seeds::Seasons.seed!