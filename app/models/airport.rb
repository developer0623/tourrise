# frozen_string_literal: true

class Airport
  class << self
    def find_by_iata(code)
      all.find do |airport|
        airport.iata == code.to_s
      end
    end

    def all
      @all ||= all_as_json.map do |_, airport|
        new(airport)
      end
    end

    def all_as_json
      @all_as_json ||= JSON.parse(File.read(file_path))
    end

    private

    def file_path
      @file_path ||= Rails.root.join("db", "data", "airports.json")
    end
  end

  attr_accessor :iata, :name

  def initialize(attributes)
    @iata = attributes["iata"]
    @name = attributes["name"]
  end
end
