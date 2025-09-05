module Motivware
  def self.test(name, &block)
    puts "▶️ Running: #{name}"
    session = Capybara::Session.new(:cuprite)

    ctx = Object.new
    ctx.define_singleton_method(:visit) { |path| session.visit(path) }
    ctx.define_singleton_method(:fill_in) { |field, with:| session.fill_in(field, with: with) }
    ctx.define_singleton_method(:click) do |locator|
      session.click_button(locator) rescue session.click_link(locator)
    end
    ctx.define_singleton_method(:expect_text) do |text|
      raise "Text '#{text}' not found" unless session.has_text?(text)
    end
    ctx.define_singleton_method(:screenshot) do |path|
      FileUtils.mkdir_p(File.dirname(path))
      session.save_screenshot(path)
    end

    begin
      ctx.instance_eval(&block)
      puts "✅ #{name} passed"
    rescue => e
      puts "❌ #{name} failed: #{e.message}"
      screenshot_path = "tmp/motivware/#{name.gsub(/\s+/, '_')}.png"
      ctx.screenshot(screenshot_path)
      puts "📸 Screenshot saved to #{screenshot_path}"
    end
  end
end
