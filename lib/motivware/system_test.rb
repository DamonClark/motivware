require "action_dispatch/system_test_case"
require "capybara/rails"
require "capybara/cuprite"
require "fileutils"
require "json"

module Motivware
  class SystemTest < ActionDispatch::SystemTestCase
    # Use Cuprite instead of Selenium
    driven_by :cuprite, screen_size: [1400, 1400], options: {
      headless: false,                   # show browser for demo
      window_size: [1400, 1400],
      browser_options: { "no-sandbox": nil }
    }

    ### DSL Helpers ###

    # Fill in form field by label or input name
    def type(field, text)
      fill_in field, with: text
    end

    # Fill in Rails model forms automatically
    def fill_in_model(model_class, field, value)
      field_name = "#{model_class.name.downcase}[#{field}]"
      fill_in field_name, with: value
    end

    def click(label)
      click_button(label) rescue click_link(label)
    end

    # Assert text on page
    def expect_text(text)
      assert_text text
    end

    # Capture flash messages
    def flash_messages
      page.all(:css, '[id^=flash], [class*=flash], #notice, #alert, .alert, .notice').map(&:text).join("\n")
    end

    # Click with auto-retry for flaky interactions
    def click_with_retry(locator, attempts: 3)
      attempts.times do |i|
        begin
          click_named(locator)
          return
        rescue Capybara::ElementNotFound
          sleep 0.5 if i < attempts - 1
        end
      end
      raise "Could not find '#{locator}' after #{attempts} attempts"
    end

    ### Test runner with automatic artifacts ###

    def run_with_artifacts(test_name, snapshot_models: [])
      yield
    rescue => e
      path_base = "tmp/motivware/#{test_name.gsub(/\s+/, '_')}"
      FileUtils.mkdir_p(path_base)

      # Save screenshot
      save_screenshot("#{path_base}.png")

      # Save HTML dump
      File.write("#{path_base}.html", page.html)

      # Save flash messages
      File.write("#{path_base}_flash.txt", flash_messages)

      # Save model snapshots
      snapshot_models.each do |model|
        File.write("#{path_base}_#{model.name}.json", model.all.to_json)
      end

      puts "❌ Failed: #{test_name} (artifacts saved: screenshot + html + flash + db)"
      puts e.message
      raise e
    else
      puts "✅ Passed: #{test_name}"
    end
  end
end
