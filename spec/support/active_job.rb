RSpec.configure do |config|
  include ActiveJob::TestHelper
end

ActiveJob::Base.queue_adapter = :test
