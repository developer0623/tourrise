module Seeds
  class Users
    def self.seed!
      create_test_user
      create_api_user
    end

    def self.create_test_user
      User.where(email: 'test@example.com').first_or_create do |user|
        pp 'seed test user'
        user.first_name = 'Test'
        user.last_name = 'Employee'
        user.email = 'test@example.com'
        user.password = 'changeme'
        user.confirmed_at = Time.zone.now
      end
    end

    def self.create_api_user
      User.where(email: 'api@example.com').first_or_create do |user|
        pp 'seed api user'
        user.first_name = 'Api'
        user.last_name = 'User'
        user.email = 'api@example.com'
        user.password = 'changeme'
        user.confirmed_at = Time.zone.now
      end
    end
  end
end
