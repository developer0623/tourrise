# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Easybill::FlightsMapper do
  let(:flights) do
    [
      {
        "id"=>1508,
        "airline_code"=>"X3",
        "flight_number"=>"2162",
        "aircraft_name"=>nil,
        "arrival_at"=>"2020-12-26T15:55:00.000+00:00",
        "arrival_airport"=>"FUE",
        "departure_at"=>"2020-12-26T12:10:00.000+00:00",
        "departure_airport"=>"MUC",
        "created_at"=>"2020-12-02T17:23:00.263+01:00",
        "updated_at"=>"2020-12-02T17:23:00.263+01:00"
      },
      {
        "id"=>1509,
        "airline_code"=>"5Q",
        "flight_number"=>"3432",
        "aircraft_name"=>nil,
        "arrival_at"=>"2021-01-06T20:55:00.000+00:00",
        "arrival_airport"=>"MUC",
        "departure_at"=>"2021-01-06T15:25:00.000+00:00",
        "departure_airport"=>"FUE",
        "created_at"=>"2020-12-02T17:23:00.270+01:00",
        "updated_at"=>"2020-12-02T17:23:00.270+01:00"
      }
    ]
  end

  subject(:mapper) { described_class.new(flights) }

  describe '.to_easybill_text_items' do
    it 'maps the flights' do
      result = mapper.to_easybill_text_items

      expected_result = {
        type: "TEXT",
        description: '<table style="width: 100%;">' \
                        '<thead>' \
                          '<tr>' \
                            '<th style="width: 45%"> Abflug</th>' \
                            '<th style="width: 45%"> Ankunft</th>' \
                            '<th style="width: 10%"> Flugnr.</th>' \
                          '</tr>' \
                        '</thead>' \
                        '<tbody>' \
                        '<tr>' \
                          '<td>  26.12.2020, 12:10 Uhr Munich Airport</td>' \
                          '<td>  26.12.2020, 15:55 Uhr Fuerteventura Airport</td>' \
                          '<td>  X32162</td>' \
                        '</tr>' \
                        '<tr>' \
                          '<td>  06.01.2021, 15:25 Uhr Fuerteventura Airport</td>' \
                          '<td>  06.01.2021, 20:55 Uhr Munich Airport</td>' \
                          '<td>  5Q3432</td>' \
                        '</tr>' \
                        '</tbody>' \
                      '</table>'
      }

      expect(result).to eq(expected_result)
    end
  end
end
