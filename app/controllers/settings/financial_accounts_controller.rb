# frozen_string_literal: true

module Settings
  class FinancialAccountsController < ApplicationController
    def index
      @financial_accounts = FinancialAccount.all
    end

    def new
      @financial_account = FinancialAccount.new
    end

    def create
      @financial_account = FinancialAccount.new(financial_account_params)

      if @financial_account.save
        redirect_to settings_financial_accounts_path
      else
        render "new", status: :unprocessable_entity
      end
    end

    def edit
      @financial_account = FinancialAccount.find(params[:id])
    end

    def update
      @financial_account = FinancialAccount.find(params[:id])

      if @financial_account.update(financial_account_params)
        redirect_to settings_financial_accounts_path
      else
        render "edit", status: :unprocessable_entity
      end
    end

    private

    def financial_account_params
      params.require(:financial_account).permit(
        :name,
        :before_service_year,
        :during_service_year
      )
    end
  end
end
