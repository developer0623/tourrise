# frozen_string_literal: true

class ParticipantValidator
  include ActiveModel::Validations

  attr_reader :first_name, :last_name, :placeholder

  validates :first_name, :last_name, presence: true, unless: :placeholder?

  def initialize(params = {})
    @first_name = params["first_name"]
    @last_name = params["last_name"]
    @placeholder = params["placeholder"]
  end

  private

  def placeholder?
    placeholder == "true"
  end
end
