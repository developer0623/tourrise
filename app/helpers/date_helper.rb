# frozen_string_literal: true

module DateHelper
  def birthdate_with_age(birthdate, at)
    return unless birthdate.present?

    "#{l(birthdate)} (#{calculate_age(birthdate, at)})"
  end

  def calculate_age(birthdate, now)
    return "N/A" unless birthdate.present?
    return unless now.present?

    now.year - birthdate.year - (now.month > birthdate.month || (now.month == birthdate.month && now.day >= birthdate.day) ? 0 : 1)
  end

  def earliest_birthdate
    # Based on the date of birth of oldest person alive, according to:
    # https://en.wikipedia.org/wiki/List_of_the_verified_oldest_people
    Date.new(1903, 1, 2)
  end
end
