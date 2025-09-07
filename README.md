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

## Features

* Rails-native DSL helpers:

  * `type "Label", "Value"` → type text into a field by label
  * `fill_in_model User, :email, "user@example.com"` → fill model-backed field
  * `click "Button Label"` → click button or link
  * `expect_text "Text on page"` → assert page contains text
* Automatic **screenshots** on failure
* Automatic **HTML dump** of page state on failure
* Automatic **DB snapshot** for inspected models
* CLI runner for test files
* Minimal setup — no Node.js required

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

Create `test/system/user_signup_test.rb`:

```ruby
require File.expand_path("../test_helper", __dir__)
require_relative "../../../motivware/lib/motivware/system_test"

class UserSignupDemoTest < Motivware::SystemTest
  test "user signup demo showcasing all features" do
    run_with_artifacts("User signup demo", snapshot_models: [User]) do
      # Visit signup page
      visit "/users/new"

      # Fill in fields using type (label-based)
      type "Name", "Alice"

      # Fill in model-based fields
      fill_in_model User, :email, "alice@example.com"

      # Click button using clean DSL
      click "Create User"

      # Expect page content
      expect_text "Welcome Alice."
    end
  end
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

```
motivware file_path
```

* Screenshots on failure are saved in `tmp/motivware/` by default.
* Test files must must include this at the top:

```
require_relative "../../../motivware/lib/motivware/system_test"
```

---

## Contributing

This is an early PoC. Pull requests, feedback, and ideas are welcome!

---

## License

MIT License
