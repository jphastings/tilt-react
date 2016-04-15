if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require 'rspec/as_fixture'

gem "codeclimate-test-reporter", group: :test, require: nil
