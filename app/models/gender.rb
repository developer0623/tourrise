# frozen_string_literal: true

class Gender
  def initialize(id:, handle:)
    @id = id
    @handle = handle
  end
  attr_reader :id, :handle

  def name
    I18n.t("genders.#{handle}")
  end

  class << self
    GENDERS = {
      1 => Gender.new(id: 1, handle: :none),
      2 => Gender.new(id: 2, handle: :female),
      3 => Gender.new(id: 3, handle: :male),
      4 => Gender.new(id: 4, handle: :diverse)
    }.freeze

    def load(id)
      GENDERS[id]
    end

    def none
      GENDERS[1]
    end

    def female
      GENDERS[2]
    end

    def male
      GENDERS[3]
    end

    def other
      GENDERS[4]
    end
  end
end
