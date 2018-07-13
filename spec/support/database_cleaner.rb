require 'database_cleaner'

RSpec.configure do |config|
  # Ensure Suite is set to use transactions for speed.
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  # Before each spec check if it is a Javascript test and switch between using database transactions or not where necessary.
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  # After each spec clean the database.
  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.after(:each, type: :job) do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end
