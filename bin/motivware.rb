require "capybara"
require "capybara/cuprite"
require "fileutils"

Capybara.default_driver = :cuprite

module Motivware
  # Run a test file
  def self.run(file)
    # Ensure DSL is loaded
    require_relative "motivware/dsl" if File.exist?(File.join(__dir__, "motivware/dsl.rb"))
    puts "Loading test file: #{file}"
    load file
  end
end
