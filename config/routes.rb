# frozen_string_literal: true

Rails.application.routes.draw do
  if Rails.env.development? || ENV.fetch('TRANSLATION_SERVER', false)
    mount Tolk::Engine => '/translations', :as => 'tolk'
  end

  mount Easybill::Engine => "/"

  get '/', to: redirect("/#{I18n.default_locale}")

  scope ':locale', locale: /#{PUBLIC_LOCALES.join('|')}/ do
    root "home#index"

    devise_for :users, controllers: {
      sessions: 'users/sessions',
      passwords: 'users/passwords',
      confirmations: 'users/confirmations',
      invitations: 'users/invitations'
    }

    resources :payments, only: :index

    resources :reports, only: :index

    namespace :reports do
      resources :product_skus, only: :index
    end

    resources :settings, only: :index

    namespace :settings do
      resources :cost_centers, only: %i[index new create edit update]
      resources :financial_accounts, only: %i[index new create edit update]
      resources :occupation_configurations, only: %i[index]
      resources :tags, only: %i[index new create edit update destroy]
      resources :custom_attributes, except: :show
      resources :frontoffice_settings, only: %i[new create edit update]
      resources :global_configurations, only: %i[new create edit update]
      resources :cancellation_reasons, only: %i[index new create edit update destroy]
      resources :statements, only: :index
      resource :me
    end

    resources :users, only: %i[index show new create edit update]

    resources :customers, only: %i[index new create show edit update]

    resources :products, only: %i[index show new create edit update] do
      resources :product_skus, only: %i[edit update destroy]
      resources :seasons, only: %i[new create]
      resources :product_participants, only: :index
      resources :product_booking_resource_skus, only: :index
    end

    resources :seasons, only: %i[edit update destroy]

    resources :inventories, only: %i[index show new create edit update] do
      get '/availabilities/:year/:month/:day', to: 'availabilities#day_view', as: :day_view
      resources :availabilities, only: :show
    end

    resources :bookings, only: %i[index new show create edit update] do
      member do
        post :duplicate
        patch :assign_employee
        patch :commit
        patch :cancel
        patch :close
        patch :reopen
        patch :unassign_employee
      end

      resources :booking_offers, only: :create do
        member do
          patch :publish
          patch :unpublish
        end
      end

      resources :booking_invoices, only: %i[new create] do
        member do
          patch :publish
          patch :unpublish
        end
      end

      resources :advance_booking_invoices, only: %i[new create] do
        member do
          patch :publish
          patch :unpublish
        end
      end

      resources :booking_credits, only: %i[new create edit update destroy]

      resources :booking_resource_skus, only: %i[show new create edit update destroy] do
        member do
          post :duplicate
          patch :block
          patch :unblock
        end
      end

      resources :booking_resource_sku_groups, only: %i[new create edit]

      resources :booking_events, only: :index
    end

    resources :booking_resource_sku_groups, only: %i[update destroy]

    resources :booking_invoices, only: :show
    resources :advance_booking_invoices, only: :show
    resources :booking_offers, only: :show

    resources :resource_types, only: %i[index show]

    resources :resources, shallow: true do
      resources :resource_skus do
        resources :resource_sku_pricings, only: %i[new create edit update destroy] do
          collection do
            get :bulk_edit
          end
        end

        member do
          get :check_availability
        end
      end
    end

    resources :image_uploads, only: %i[create]

    resources :cancellations, only: :create

    namespace :frontoffice do
      resources :products, param: :sku_handle, only: %i[index show] do
        resources :bookings, only: %i[new create]
        resources :inquiries, only: %i[new create] do
          get :success, on: :collection
        end
      end

      resources :bookings, param: :scrambled_id, only: %i[edit update destroy] do
        resources :offers, controller: 'booking_offers', only: :show, param: :scrambled_id do
          member do
            patch :accept
            patch :reject
          end
        end

        resources :invoices, controller: 'booking_invoices', only: :show, param: :scrambled_id
        resources :advance_invoices, controller: 'advance_booking_invoices', only: :show, param: :scrambled_id

        member do
          get :summary
          post :submit
        end

        resources :accommodations, only: :index do
          member do
            post :select
          end
        end
      end
    end
  end

  namespace :api do
    defaults format: :json do
      resources :tag_groups, only: :index
      resources :customers, only: %i[show index]
      resources :flights, only: %i[show index]
      resources :resource_skus, only: :index
      resources :bookings do
        resources :booking_resource_skus, only: :create
        member do
          patch :customer
        end
      end
      namespace :v1 do
        resources :bookings, only: %i[index show]
        resources :booking_invoices, only: :index
        resources :booking_resource_skus, only: :index
      end
    end
  end

  class RedirectConstraints
    def self.starts_with?(path)
      path.starts_with?(%r{\/(#{list.join('|')})\/})
    end

    def self.list
      [
        *PUBLIC_LOCALES.map(&:to_s),
        "rails",
      ]
    end
  end

  get '*path', to: redirect("/#{I18n.default_locale}/%{path}"),
               constraints: lambda { |request| !RedirectConstraints.starts_with?(request.fullpath) }
end
