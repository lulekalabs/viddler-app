ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def assert_error_on(record, *fields)
    record.valid?
    fields.each do |field|
      assert !record.errors[field.to_sym].empty?, "expected errors on #{field}"
    end
  end

  def assert_no_error_on(record, *fields)
    record.valid?
    fields.each do |field|
      assert record.errors[field.to_sym].empty?, "expected no errors on #{field}"
    end
  end
end
