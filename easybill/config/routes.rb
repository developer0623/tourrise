# frozen_string_literal: true

Easybill::Engine.routes.draw do
  scope ":locale", locale: /#{PUBLIC_LOCALES.join('|')}/ do
    scope :easybill do
      resources :offers, only: :show
      resources :invoices, only: :show

      resources :settings, only: :index

      resources :employees, only: %i[index new create edit update destroy]

      resources :product_configurations, except: :destroy

      namespace :api do
        defaults format: :json do
          namespace :v1 do
            resources :offers, param: :booking_offer_id, only: :show
            resources :invoices, param: :booking_invoice_id, only: :show
          end
        end
      end
    end
  end
end
