class AddOccupationConfigurationReferenceToResourceSkus < ActiveRecord::Migration[6.0]
  def change
    add_reference :resource_skus, :occupation_configuration, index: true
  end
end
