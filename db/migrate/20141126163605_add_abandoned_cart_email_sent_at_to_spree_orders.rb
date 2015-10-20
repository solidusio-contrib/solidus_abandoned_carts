class AddAbandonedCartEmailSentAtToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :abandoned_cart_email_sent_at, :datetime
  end
end
