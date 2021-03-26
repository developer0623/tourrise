# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :load_home, only: :index

  def index; end

  private

  def load_home
    context = LoadHome.call(controller: self)
    @bookings = context.bookings.decorate
  end
end
