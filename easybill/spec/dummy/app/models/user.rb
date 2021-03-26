# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         :trackable

  def name
    "#{first_name} #{last_name}"
  end

  protected

  def password_required?
    invitation_accepted?
  end
end
