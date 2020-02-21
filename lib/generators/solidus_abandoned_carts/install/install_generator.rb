# frozen_string_literal: true

module SolidusAbandonedCarts
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      class_option :auto_run_migrations, type: :boolean, default: false

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=solidus_abandoned_carts'
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask('Would you like to run the migrations now? [Y/n]'))
        if run_migrations
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!' # rubocop:disable Rails/Output
        end
      end

      def copy_initializer
        copy_file 'initializer.rb', 'config/initializers/solidus_abandoned_carts.rb'
      end
    end
  end
end
