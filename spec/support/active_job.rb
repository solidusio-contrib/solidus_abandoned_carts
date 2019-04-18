# frozen_string_literal: true

RSpec.configure do
  include ActiveJob::TestHelper
end

ActiveJob::Base.queue_adapter = :test
