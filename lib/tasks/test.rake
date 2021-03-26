# frozen_string_literal: true

namespace :test do
  task :rubocop do
    require "rubocop/rake_task"
    RuboCop::RakeTask.new
    Rake::Task["rubocop"].execute
  end

  task :all do
    Rake::Task["test:app"].execute
    Rake::Task["test:easybill"].execute
    Rake::Task["test:rubocop"].execute
  end

  desc "Running app tests"
  task :app do
    pp "Running app specs..."
    Rake::Task["spec"].execute
  end

  desc "Running easybill tests"
  task :easybill do
    Dir.chdir("easybill") do
      pp "Running easybill specs..."
      Rake::Task["spec"].execute
    end
  end
end
