require 'capybara-screenshot/rspec'

Capybara::Screenshot.autosave_on_failure = true

# Capybara::Screenshot.testunit_paths << 'spec/features'

# -----------------------------------------------------------------------------------------
# Driver configuration
# -----------------------------------------------------------------------------------------

# Capybara::Screenshot.webkit_options = { width: 1024, height: 768 }

# # The driver name should match the Capybara driver config name.
# Capybara::Screenshot.register_driver(:selenium_firefox) do |driver, path|
#   driver.super_dooper_render(path)
# end

# -----------------------------------------------------------------------------------------
# Custom screenshot filename
# -----------------------------------------------------------------------------------------

Capybara::Screenshot.register_filename_prefix_formatter(:rspec) do |example|
  "#{example.location.split('/').last.to_s}_#{example.description.gsub(' ', '-').gsub(/^.*\/spec\//,'')}"
end

# -----------------------------------------------------------------------------------------
# Custom screenshot directory
# -----------------------------------------------------------------------------------------

Capybara.save_path = Rails.root.join('tmp', 'capybara', 'screenshots')

# -----------------------------------------------------------------------------------------
# Pruning old screenshots automatically
# -----------------------------------------------------------------------------------------

# # Keep only the screenshots generated from the last failing test suite
# Capybara::Screenshot.prune_strategy = :keep_last_run

# Keep up to the number of screenshots specified in the hash
Capybara::Screenshot.prune_strategy = { keep: 2 }
