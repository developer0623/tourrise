# frozen_string_literal: true

namespace :review_apps do
  task :prepare_database do
    puts "> Starting review_apps:prepare_database rake task"
    if ENV["HEROKU_PIPELINE"] == "review_apps"
      puts ">> Printing out current database configuration:"
      puts Rails.configuration.database_configuration

      if Rails.configuration.database_configuration["production"]["url"].present?
        puts ">>> Invoking rake db:migrate task:"
        Rake::Task["db:migrate"].invoke

        puts ">>> Invoking rake db:seed task:"
        Rake::Task["db:seed"].invoke
      else
        puts ">>> Databae URL is not yet available. Skipping rake db commands"
      end
    end
    puts "< Exiting review_apps:prepare_database rake task"
  end
end
