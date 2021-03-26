# frozen_string_literal: true

namespace :translations do
  task sync: :environment do
    ActiveRecord::Base.establish_connection(ENV["TRANSLATION_SERVER_URL"])
    Tolk::Locale.sync!
    ActiveRecord::Base.establish_connection(ENV["RAILS_ENV"])
  end

  task dump: :environment do
    ActiveRecord::Base.establish_connection(ENV["TRANSLATION_SERVER_URL"])
    Tolk::Locale.dump_all
    ActiveRecord::Base.establish_connection(ENV["RAILS_ENV"])
  end

  task import: :environment do
    ActiveRecord::Base.establish_connection(ENV["TRANSLATION_SERVER_URL"])
    Rake::Task["translations:sync"].invoke
    Tolk::Locale.import_secondary_locales
    ActiveRecord::Base.establish_connection(ENV["RAILS_ENV"])
  end

  task :update_locale, %i[old_name new_name] => :environment do |_t, args|
    ActiveRecord::Base.establish_connection(ENV["TRANSLATION_SERVER_URL"])
    old_name = args[:old_name]
    new_name = args[:new_name]
    puts Tolk::Locale.rename(old_name, new_name)
    ActiveRecord::Base.establish_connection(ENV["RAILS_ENV"])
  end
end
