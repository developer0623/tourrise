# frozen_string_literal: true

class ResourceSkuOccupationService
  attr_reader :resource_sku

  def initialize(resource_sku)
    @resource_sku = resource_sku
  end

  def matches_occupation_configuration?(adults:, kids: 0, babies: 0)
    return true unless occupation_configuration.present?

    occupation_configuration.occupiable_with_count?(adults + kids + babies) &&
      occupation_configuration.occupiable_by_adults_count?(adults) &&
      occupation_configuration.occupiable_by_kids_count?(kids) &&
      occupation_configuration.occupiable_by_babies_count?(babies)
  end

  private

  def occupation_configuration
    @occupation_configuration ||= resource_sku.occupation_configuration
  end
end
