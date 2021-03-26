# frozen_string_literal: true

module Settings
  class TagsController < ApplicationController
    def index
      context = Tags::ListTags.call

      if context.success?
        @tags = context.tags.decorate
      else
        flash.now[:error] = context.message
        render "index"
      end
    end

    def new
      @tag = Tag.new
    end

    def create
      context = ::Tags::CreateTag.call(params: tag_params.to_h)

      if context.success?
        flash[:success] = I18n.t("settings.tags.create.success")
        redirect_to settings_tags_path
      else
        @tag = context.tag
        flash.now[:error] = context.message
        render "new", status: :unprocessable_entity
      end
    end

    def edit
      @tag = Tag.find(params[:id])
    end

    def update
      context = ::Tags::UpdateTag.call(tag_id: params[:id], params: tag_params.to_h)

      if context.success?
        flash[:success] = I18n.t("settings.tags.update.success")
        redirect_to settings_tags_path
      else
        @tag = context.tag
        flash.now[:error] = context.message
        render "edit", status: :unprocessable_entity
      end
    end

    private

    def tag_params
      params.require(:tag).permit(
        :name,
        :tag_group_id,
        :tag_group_name,
        :handle
      )
    end
  end
end
