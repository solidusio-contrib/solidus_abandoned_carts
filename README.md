
SolidusAbandonedCarts
===================
[![Build Status](https://travis-ci.org/solidusio-contrib/solidus_abandoned_carts.svg?branch=master)](https://travis-ci.org/solidusio-contrib/solidus_abandoned_carts)

Take some action for abandoned (incompleted) carts.

Override `Spree::Order#abandoned_cart_actions` with your logic.
By default an email is sent, see `AbandonedCartMailer`.

You have to trigger the method in some way, an example recurring ActiveJob worker
is included.

Installation
------------

Add this line to your solidus application's Gemfile:

```ruby
gem 'solidus_abandoned_carts', github: 'solidusio-contrib/solidus_abandoned_carts'
```

And then execute:

```shell
$ bundle
$ bundle exec rails g solidus_abandoned_carts:install
```

Usage
-----

There are some preferences you can change (defaults are shown here):

```ruby
SolidusAbandonedCarts::Config.tap do |config|
  # when an order can be marked as abandoned
  config.abandoned_after_minutes = 1440 # 24 hours
  # how often the sidekiq worker should run
  config.worker_frequency_minutes = 30
end
```

You can perform the processing of the abandoned carts at any time:

```ruby
Spree::AbandonedCartJob.perform
```

To modify the email, you just have to override `I18n.t('spree.abandoned_cart_subject')`
and `app/views/spree/abandoned_cart_mailer/abandoned_cart_email.html.erb`.


Testing
-------

Then just run the following to automatically build a dummy app if necessary and
run the tests:

```shell
bundle exec rake
```
