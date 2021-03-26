# frozen_string_literal: true

class ResourcesController < ApplicationController
  def index
    context = Resources::ListResources.call(page: params[:page], filter: filter_params, sort: sort_params)

    @resources = context.resources.decorate
  end

  def show
    load_resource
    load_resource_skus
  end

  def new
    resource = Resource.new
    resource.resource_skus.new unless resource.resource_skus.any?
    @resource = resource.decorate
  end

  def create
    context = Resources::CreateResource.call(params: resource_params)

    if context.success?
      redirect_to resource_path(context.resource)
    else
      @resource = context.resource.decorate
      flash.now[:error] = context.message
      render "new", status: :unprocessable_entity
    end
  end

  def edit
    load_resource
    @resource.resource_skus.new unless @resource.resource_skus.any?
    @resource = @resource.decorate
  end

  def update
    context = Resources::UpdateResource.call(resource_id: params[:id], params: resource_params)

    if context.success?
      flash[:success] = I18n.t("resources.update.success")
      redirect_to resource_path(context.resource)
    else
      @resource = context.resource.decorate
      flash[:error] = context.message
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    context = Resources::DestroyResource.call(resource_id: params[:id])

    if context.success?
      flash[:success] = I18n.t("resources.destroy.success")
      redirect_to resources_path, status: :see_other
    else
      flash[:success] = context.message
      redirect_to resource_path(context.resource)
    end
  end

  private

  def resource_params
    params.require(:resource).permit!.to_h
  end

  def load_resource
    context = Resources::LoadResource.call(resource_id: params[:id])

    if context.success?
      @resource = context.resource
    else
      flash.now[:error] = context.message
      render "errors/404"
    end
  end

  def load_resource_skus
    context = Resources::ListResourceSkus.call(resource_id: params[:id], page: params[:page], sort: sort_params)

    if context.success?
      @resource_skus = context.resource_skus.decorate
    else
      flash.now[:error] = context.message
    end
  end

  def filter_params
    {
      resource_type_id: params[:resource_type],
      q: params[:q]
    }
  end
end
