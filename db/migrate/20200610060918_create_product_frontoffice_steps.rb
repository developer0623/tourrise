class CreateProductFrontofficeSteps < ActiveRecord::Migration[6.0]
  class BookingFormStep
    include ActiveModel::Model

    attr_accessor :id,
                  :position,
                  :handle,
                  :template

    validates :id, :position, :handle, presence: true

    def self.all(template)
      all_steps(template).map.with_index(1) do |handle, index|
        BookingFormStep.new(
          id: index,
          position: index,
          handle: handle,
          template: template
        )
      end
    end

    def self.find_by_handle(template, step_handle)
      found_step = all(template).find { |step| step.handle.to_sym == step_handle.to_sym }
      raise "not_found" unless found_step.present?

      found_step
    end

    def self.all_as_json
      @all_as_json = {
        "default" => [ "request", "accommodation_request", "flight_request", "insurance_request", "contact", "participants", "summary" ],
        "allgaeu-triathlon" => [ "request", "accommodation_request", "insurance_request", "contact", "participants", "summary" ],
        "domestic-camps" => [ "request", "accommodation_request", "rentalbike_request", "training_package_request", "insurance_request", "contact", "participants", "summary" ],
        "hht-training-camps" => [ "request", "accommodation_request", "flight_request", "rentalbike_request", "training_package_request", "insurance_request", "contact", "participants", "summary" ],
        "hht-im-trip" => [ "request", "accommodation_request", "flight_request", "rentalcar_request", "training_package_request", "insurance_request", "contact", "participants", "summary" ],
        "hht-hawaii" => [ "request", "accommodation_request", "flight_request", "rentalbike_request", "rentalcar_request", "training_package_request", "island_hopping_request", "insurance_request", "contact", "participants", "summary" ],
        "pro-individual" => [ "request", "accommodation_request", "flight_request", "rentalbike_request", "training_package_request", "contact", "participants", "summary" ],
        "pro-group" => [ "request", "contact", "participants", "summary" ]
      }
    end

    def self.all_steps(template)
      all_as_json.key?(template) ? all_as_json[template.to_s] : all_as_json["default"]
    end

    def next_step_handle
      return if position == all.length

      all[position]
    end

    def previous_step_handle
      return if position == 1

      all[position - 2]
    end

    def to_hash
      {
        'id': id,
        'position': position,
        'handle': handle
      }
    end

    private

    def all
      @all ||= self.class.all_steps(template)
    end
  end

  def up
    create_table :product_frontoffice_steps do |t|
      t.belongs_to :product
      t.belongs_to :frontoffice_step
      t.timestamps
    end

    steps = %w[
      request accommodation_request flight_request rentalbike_request rentalcar_request training_package_request
      island_hopping_request insurance_request contact participants summary
    ]

    steps.each.with_index(1) do |step, index|
      FrontofficeStep.create(
        handle: step,
        name: step,
        description: step,
        position: index
      )
    end

    Product.all.each do |product|
      product.frontoffice_steps << FrontofficeStep.where(handle: BookingFormStep.all_steps(product.frontoffice_template))
    end
  end

  def down
    drop_table :product_frontoffice_steps
  end
end
