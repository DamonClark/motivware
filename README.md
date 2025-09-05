# Motivware

**Rails-native system testing for modern apps — written entirely in Ruby.**

---

## Background

Rails system tests are great, but modern test automation frameworks like **Playwright** and **Cypress** haven’t fully served the Rails ecosystem:

* **Cypress** only works with TypeScript/JavaScript.
* **Playwright** doesn’t offer a way to write tests in Ruby.

Some Rails developers have built gems or utilities around these frameworks, but there hasn’t been a truly **Rails-native, Ruby-first automation testing framework**.

**Motivware** fills this gap — a lightweight system testing tool built for Rails, written entirely in Ruby. You can write full-featured system tests using a **simple DSL**, get Turbo-aware waits, automatic screenshots on failure, and run everything with pure Ruby.

---

## Installation

Add this to your Rails app `Gemfile` (PoC local install):

```ruby
gem "motivware", path: "../motivware"
```

Then run:

```bash
bundle install
```

Or, after building the gem:

```bash
gem build motivware.gemspec
gem install ./motivware-0.1.0.gem
```

---

## CLI Usage

```bash
motivware path/to/test_file.rb
```

Example:

```bash
motivware test/system/login_test.rb
```

---

## Example Test File

Create `test/system/login_test.rb`:

```ruby
require "motivware"

Motivware.test "dummy test" do
  puts "✅ Rails app loaded successfully"
end
```

Run it:

```bash
ruby ../motivware/exe/motivware test/system/login_test.rb
```

Expected output:

```
Loading test file: test/system/login_test.rb
▶️ Running: dummy test
✅ Rails app loaded successfully
✅ dummy test passed
```

---

## Features (v0.1 PoC)

* Rails-native, Ruby-first DSL
* CLI runner for test files
* Minimal setup — no Node.js required
* Turbo/Hotwire-aware waits (future improvement)
* Screenshots on test failure

---

## Next Steps

* Add real Rails page tests (forms, logins, dashboards)
* Implement more DSL helpers (`within`, `assert_selector`, etc.)
* Turbo/Hotwire wait improvements
* Automatic database cleanup between tests

---

## Why Motivware?

Motivware was created because Rails developers need **a modern test automation framework that feels native to Rails**. Unlike Cypress or Playwright:

* You can write tests **entirely in Ruby**.
* You don’t need TypeScript, JavaScript, or Node.js.
* It integrates naturally with Rails features like Turbo/Hotwire and ActiveRecord.

Motivware gives Rails developers **the power of modern test automation** without leaving the Rails ecosystem.

---

## Development Notes

* The gem is currently PoC (v0.1.0).
* CLI runs a test file via:

```ruby
Motivware.run(file_path)
```

* The DSL method `Motivware.test` is top-level in the test file.
* Screenshots on failure are saved in `tmp/motivware/` by default.
* Test files must `require "motivware"` at the top.

---

## Contributing

This is an early PoC. Pull requests, feedback, and ideas are welcome!

---

## License

MIT License
