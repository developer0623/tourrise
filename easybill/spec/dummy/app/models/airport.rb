# frozen_string_literal: true

class Airport
  def self.find(code)
    all.find do |airport|
      airport.iata == code.to_s
    end
  end

  def self.all
    @all ||= all_as_json.map do |airport|
      new(airport)
    end
  end

  def self.all_as_json
    @all_as_json ||= JSON.parse(File.read(file_path))
  end

  def self.file_path
    @file_path ||= Rails.root.join('db', 'data', 'airports.json')
  end

  attr_accessor :iata, :name, :iso

  def initialize(attributes)
    @iata = attributes['iata']
    @name = attributes['name']
    @iso = attributes['iso']
  end
end
