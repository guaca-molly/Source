class AddStripeSubscriptionToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :stripe_subscription, :string
  end
end
