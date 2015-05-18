# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

# Rails doesn't run test under diff location
# because we created test/lib, rails doesn't know where the test file is
namespace :test do
  # create a new task inside test
  Rake::TestTask.new do |t|
    # it is called lib
    t.name = "lib"
    # this file matches the exec pattern
    t.pattern = "test/lib/**/*_test.rb"
    # add all the test
    t.libs << "test"
  end
end