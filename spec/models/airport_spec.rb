# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Airport, type: :model do
  before { allow(Airport).to receive(:file_path) { 'spec/fixtures/airport_new_fixture.json' } }

  describe '#all_as_json' do
    subject { described_class.all_as_json }

    let(:expected_result) do
      {
        "GKA" => {
          "name" => "Goroka Airport",
          "city" => "Goroka",
          "country" => "Papua New Guinea",
          "iata" => "GKA",
          "icao" => "AYGA",
          "latitude" => "-6.081689834590001",
          "longitude" => "145.391998291",
          "altitude" => "5282",
          "timezone" => "10",
          "dst" => "U",
          "tz_name" => "Pacific/Port_Moresby"
        },
        "MAG" =>  {
          "name" => "Madang Airport",
          "city" => "Madang",
          "country" => "Papua New Guinea",
          "iata" => "MAG",
          "icao" => "AYMD",
          "latitude" => "-5.20707988739",
          "longitude" => "145.789001465",
          "altitude" => "20",
          "timezone" => "10",
          "dst" => "U",
          "tz_name" => "Pacific/Port_Moresby"
        }
      }
    end

    it { is_expected.to eq(expected_result) }
  end

  describe '#find_by_iata' do
    subject { described_class.find_by_iata(iata) }

    let(:iata) { "GKA" }
    let(:name) { "Goroka Airport" }

    it { expect(subject.iata).to eq(iata) }
    it { expect(subject.name).to eq(name) }
  end

  describe '#all' do
    subject { described_class.all }

    let(:attributes) do
      [
        {
          "iata" => "GKA",
          "name" => "Goroka Airport"
        },
        {
          "iata" => "MAG",
          "name" => "Madang Airport"
        }
      ]
    end

    it do
      attributes.each.with_index do |airport, index|
        expect(subject[index].iata).to eq(airport['iata'])
        expect(subject[index].name).to eq(airport['name'])
      end
    end
  end
end
