module Seeds
  class OccupationConfigurations
    def self.seed!
      create_single_occupancies
      create_double_occupancy
      create_threesome_occupancy
      create_foursome_occupancy
      create_fivesome_occupancy
    end

    def self.create_single_occupancies
      OccupationConfiguration.find_or_create_by(name: '1er Belegung') do |configuration|
        configuration.min_occupancy = 1
        configuration.max_occupancy = 1

        configuration.min_adults = 1
        configuration.max_adults = 1

        configuration.min_kids = 0
        configuration.max_kids = 0

        configuration.min_babies = 0
        configuration.max_babies = 0
      end
    end

    def self.create_double_occupancy
      OccupationConfiguration.find_or_create_by(name: '2er Belegung') do |configuration|
        configuration.min_occupancy = 2
        configuration.max_occupancy = 2

        configuration.min_adults = 1
        configuration.max_adults = 2

        configuration.min_kids = 0
        configuration.max_kids = 1

        configuration.min_babies = 0
        configuration.max_babies = 1
      end
    end

    def self.create_threesome_occupancy
      OccupationConfiguration.find_or_create_by(name: '3er Belegung') do |configuration|
        configuration.min_occupancy = 3
        configuration.max_occupancy = 3

        configuration.min_adults = 1
        configuration.max_adults = 3

        configuration.min_kids = 0
        configuration.max_kids = 2

        configuration.min_babies = 0
        configuration.max_babies = 2
      end
    end

    def self.create_foursome_occupancy
      OccupationConfiguration.find_or_create_by(name: '4er Belegung') do |configuration|
        configuration.min_occupancy = 4
        configuration.max_occupancy = 4

        configuration.min_adults = 1
        configuration.max_adults = 4

        configuration.min_kids = 0
        configuration.max_kids = 3

        configuration.min_babies = 0
        configuration.max_babies = 3
      end
    end

    def self.create_fivesome_occupancy
      OccupationConfiguration.find_or_create_by(name: '5er Belegung') do |configuration|
        configuration.min_occupancy = 5
        configuration.max_occupancy = 5

        configuration.min_adults = 1
        configuration.max_adults = 5

        configuration.min_kids = 0
        configuration.max_kids = 4

        configuration.min_babies = 0
        configuration.max_babies = 4
      end
    end
  end
end

