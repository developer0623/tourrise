# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         :trackable,
         :invitable,
         validate_on_invite: true

  validates :invited_by, presence: true, if: -> { invited_to_sign_up? }

  scope :without_system_users, -> { where.not(email: FrontofficeUser.email) }

  def self.invite_key_fields
    %i[first_name last_name email]
  end

  def name
    "#{first_name} #{last_name}"
  end

  protected

  def password_required?
    invitation_accepted? ? super : false
  end
end
