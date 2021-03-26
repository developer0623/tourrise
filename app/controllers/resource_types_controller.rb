# frozen_string_literal: true

class ResourceTypesController < ApplicationController
  before_action :load_resource_type, only: %i[show]

  def index
    context = ResourceTypes::ListResourceTypes.call(page: params[:page], filter: filter_params)
    @resource_types = context.resource_types.decorate
  end

  def show; end

  private

  def load_resource_type
    @resource_type = ResourceType.find(params[:id]).decorate
  end

  def filter_params
    { q: params[:q] }
  end

  def resource_type_params
    params.permit(:resource_type).require(:label, :handle)
  end
end
