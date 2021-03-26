# frozen_string_literal: true

namespace :airports do
  def check_for_empty_data(field)
    # OpenFlights uses "\\N" (i.e. a literal backslash followed by a capital N) to
    # indicate a null field.
    if field == "\\N"
      nil
    else
      field
    end
  end

  desc "Updates airports"
  task update: :environment do
    raw_data = open("https://raw.githubusercontent.com/jpatokal/openflights/master/data/" \
                    "airports.dat").read + File.read("db/data/patches.dat")

    cleaned_data = raw_data.gsub(/\\"/, '""')

    cleaned_data = CSV.parse(cleaned_data).each_with_object({}) do |row, accumulator|
      iata_code = row[4]

      # We'll skip other airports which don't have IATA codes
      next unless iata_code != "\\N"

      accumulator[iata_code] = {
        name: check_for_empty_data(row[1]),
        city: check_for_empty_data(row[2]),
        country: check_for_empty_data(row[3]),
        iata: iata_code,
        icao: check_for_empty_data(row[5]),
        latitude: check_for_empty_data(row[6]),
        longitude: check_for_empty_data(row[7]),
        altitude: check_for_empty_data(row[8]),
        timezone: check_for_empty_data(row[9]),
        dst: check_for_empty_data(row[10]),
        tz_name: check_for_empty_data(row[11])
      }
    end

    File.open("db/data/airports.json", "w").puts JSON.generate(cleaned_data)
  end
end
