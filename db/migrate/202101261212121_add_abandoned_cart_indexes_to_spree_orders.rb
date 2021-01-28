# frozen_string_literal: true

class AddAbandonedCartIndexesToSpreeOrders < SolidusSupport::Migration[5.1]
  def change
    add_index :spree_orders, [:email, :updated_at]

    if ActiveRecord::Base.connection.adapter_name == 'MySQL'
      add_index :spree_orders, [:updated_at, :email, :completed_at, :item_count]
    else
      add_index :spree_orders, :updated_at, where: <<~SQL.squish
        email IS NOT NULL
        AND completed_at IS NULL
        AND item_count > 0
      SQL
    end
  end
end
