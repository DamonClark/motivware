require "capybara"
require "capybara/cuprite"
require "fileutils"

module Motivware
  Capybara.default_driver = :cuprite

  def self.run(file)
    puts "Loading test file: #{file}"
    load file
  end

  def self.test(name, &block)
    session = Capybara::Session.new(:cuprite)
    ctx = Context.new(session)
    puts "▶ Running: #{name}"
    ctx.instance_eval(&block)
    puts "✅ Passed: #{name}"
  rescue => e
    ctx&.screenshot("tmp/motivware/#{name.gsub(/\s+/, '_')}.png")
    puts "❌ Failed: #{name} (screenshot saved)"
    puts e.message
  end

  class Context
    def initialize(session)
      @session = session
    end

    def visit(path)
      @session.visit(path)
    end

    def fill_in(locator, with:)
      @session.fill_in(locator, with: with)
    end

    def click(locator)
      @session.click_button(locator)
    rescue Capybara::ElementNotFound
      @session.click_link(locator)
    end

    def expect_text(text)
      raise "Expected text '#{text}' not found" unless @session.has_text?(text)
    end

    def screenshot(path)
      FileUtils.mkdir_p(File.dirname(path))
      @session.save_screenshot(path)
    end
  end
end
