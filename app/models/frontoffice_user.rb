# frozen_string_literal: true

class FrontofficeUser
  def self.id
    user.id
  end

  def self.email
    "frontoffice_user@backoffice.com"
  end

  def self.user
    @user ||= User.find_or_create_by(email: email) do |user|
      user.first_name = "Frontoffice"
      user.last_name = "User"
      user.confirmed_at = Time.zone.now
    end
  end
end
