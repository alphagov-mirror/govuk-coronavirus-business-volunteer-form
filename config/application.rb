# frozen_string_literal: true

require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# Disables ActiveRecord for smoke tests
require "active_record/railtie" unless ENV["RAILS_ENV"] == "smoke_test"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Raven.configure do |config|
  config.dsn = ENV["SENTRY_DSN"]
end

module CoronavirusForm
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified
    # here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.eager_load_paths << Rails.root.join("lib")
    config.autoload_paths << Rails.root.join("lib")

    # By default don't upload error pages to S3
    config.upload_error_pages_to_s3 = ENV["UPLOAD_ERROR_PAGES_TO_S3"] || false

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.courtesy_copy_email = "coronavirus-services-smoke-tests@digital.cabinet-office.gov.uk"

    config.active_job.queue_adapter = :sidekiq

    config.courtesy_copy_email = "coronavirus-services-smoke-tests@digital.cabinet-office.gov.uk"
  end
end
