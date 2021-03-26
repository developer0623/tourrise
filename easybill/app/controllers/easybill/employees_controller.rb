# frozen_string_literal: true

module Easybill
  class EmployeesController < ApplicationController
    def index
      @employees = Employee.all
    end

    def new
      @employee = Employee.new
    end

    def create
      @employee = Employee.new(employee_params)
      if @employee.save
        flash[:success] = "Easybill MitarbeiterIn wurde erfolgreich angelegt"
        redirect_to employees_path
      else
        flash[:error] = @employee.errors.full_messages
        render "new", status: :unprocessable_entity
      end
    end

    def show
      @employee = Employee.find(params[:id])
    end

    def edit
      @employee = Employee.find(params[:id])
    end

    def update
      @employee = Employee.find(params[:id])
      if @employee.update(employee_params)
        flash[:success] = "Easybill MitarbeiterIn wurde erfolgreich aktualisiert"
        redirect_to employees_path
      else
        flash[:error] = @employee.errors.full_messages
        render "edit", status: :unprocessable_entity
      end
    end

    def destroy
      @employee = Employee.find(params[:id])
      if @employee.destroy
        flash[:success] = "Easybill Verknüpfung zu MitarbeiterIn wurde erfolgreich entfernt"
        redirect_to employees_path
      else
        flash[:error] = @employee.errors.full_messages
        redirect_to edit_employee_path(@employee)
      end
    end

    private

    def employee_params
      params.require(:employee).permit(:user_id, :api_key)
    end
  end
end
