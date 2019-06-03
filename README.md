# SolidusAbandonedCarts

[![Build Status](https://travis-ci.org/solidusio-contrib/solidus_abandoned_carts.svg?branch=master)](https://travis-ci.org/solidusio-contrib/solidus_abandoned_carts)

Take action on your abandoned carts!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'solidus_abandoned_carts', github: 'solidusio-contrib/solidus_abandoned_carts'
```

Then run the following:

```console
$ bundle install
$ bundle exec rails g solidus_abandoned_carts:install
```

If you want to change the configuration, you can add the following to an initializer:

```ruby
SolidusAbandonedCarts::Config.tap do |config|
  # Amount of time after which a cart is considered abandoned.
  config.abandoned_after = 24.hours

  # The states in which a cart is considered to be abandoned.
  config.abandoned_states = [:cart, :address, :delivery, :payment, :confirm]

  # Set your own notifier class
  config.notifier_class = 'Spree::AbandonedCartNotifier'

  # Set your own mailer class
  config.mailer_class = 'Spree::AbandonedCartMailer'

  # Set your own notifier job class
  config.notifier_job_class = 'Spree::NotifyAbandonedCartJob'

  # Set your own schedule job class
  config.schedule_job_class = 'Spree::ScheduleAbandonedCartsJob'
end
```

The last step in the installation process is to configure the `Spree::ScheduleAbandonedCartsJob`
background job to run regularly. There are different ways to do this depending on the environment
your application is running in: Heroku Scheduler, cron etc.

## Usage

If you're okay with the default behavior of sending an abandoned cart email, you can simply override
the `spree.abandoned_cart_subject` translation key and the `spree/abandoned_cart_mailer/abandoned_cart_email.html.erb`
view. The default notifier will take care of sending the email for you.

If, on the other hand, you want to use custom logic, keep reading!

### Custom notifier

You can define your own abandoned cart logic by changing the `notifier_class` configuration
parameter. Here's what an example notifier could look like, if you wanted to call an external API
instead of sending an email:

```ruby
module AwesomeStore
  class AbandonedCartNotifier < Spree::AbandonedCartNotifier
    def call
      # Skip notification if this cart was already notified
      return if order.abandoned_cart_email_sent_at

      # Run your custom logic
      MyApiService.notify_abandoned_cart(order.email)

      # Mark this cart as notified
      order.touch :abandoned_cart_email_sent_at
    end
  end
end
```

## Testing

Run the following to automatically build a dummy app and run the tests:

```console
$ bundle exec rake
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/solidusio-contrib/solidus_abandoned_carts.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
