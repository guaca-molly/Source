class User < ApplicationRecord

  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true,  uniqueness: true
  validates :stripe_token, presence: true

  has_secure_password

  def save_and_subscribe
    # check if user is valid
    # check the stripe token 
    # if everything is okay add a stripe customer
    # make the stripe customer added to the plan they picked

    if self.valid?
      Stripe.api_key = Rails.application.credentials[Rails.env.to_sym][:stripe_secret_key]
      # create stripe customer 
      customer = Stripe::Customer.create(
        source: self.stripe_token,
        description: self.email ,
      )
      # make a subscription on stripe
      subscription = Stripe::Subscription.create(
          customer: customer.id, 
          items: [{ plan: self.subscription_plan}]
      )
      # save the customer id to the database 
      self.stripe_customer = customer.id
      # save the subscription id tothe datatbase
      self.stripe_subscription = subscription.id
      # save everythign
      self.save
      else 
        false
    end 
    rescue Stripe::CardError => e
      # this is from stripe
      @message = e.json_body[:error][:message]
      # then add to the model errors
      self.errors.add(:stripe_token, @message)
      # return false to our controller
      false
  end 

  def update_with_stripe(form_params)
    Stripe.api_key = Rails.application.credentials[Rails.env.to_sym][:stripe_secret_key]
    # update the model with form_params
    # check if it is valid
    # if it is valid update stripe
    # then update the database
    self.assign_attributes(form_params)
    if self.valid?
      # get the subscription from stripe
      subscription = Stripe::Subscription.retrieve(self.stripe_subscription)
      # get the first item from the subscription
      item_id = subscription.items.data[0].id
      # make our new items list
      items = [
        { id: item_id, plan: self.subscription_plan }
      ]
      # update our subscription with the new items
      subscription.items = items
      # save the subscription to stripe
      subscription.save
      # save our data to the database
      self.save
    else 
      false
    end
  end 

  def destroy_and_unsubscribe
    # get the subscription for stripe
    subscription = Stripe::Subscription.retrieve(self.stripe_subscription)
    # delete that subscription
    subscription.delete
    # remove the user completely
    self.destroy
  end 

end
