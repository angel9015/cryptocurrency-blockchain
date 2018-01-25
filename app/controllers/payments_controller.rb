class PaymentsController < ApplicationController
  layout "form_page"

  before_filter :authenticate_user!

  skip_before_filter :redirect_to_payment

  def new
    @amount = current_user.try :membership_fee
  end

  def create
    amount = current_user.membership_fee
    application_fee = ((amount * 0.054) + 30).to_i
    super_admin = nil
    User.all.each do |user|
      if user.super_admin?
        super_admin = user;
      end
    end
    puts "AMOUNT::" + amount.to_s
    puts "APPLICATION FEE::" + application_fee.to_s
    puts "ADMIN ID::" + super_admin.stripe_user_id.to_s

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => amount,
      :description => 'SC Christian Chamber of Commerce - Membership Dues',
      :currency    => 'usd',
      :application_fee => application_fee,
      :destination => super_admin.stripe_user_id
    )

    current_user.payments.create(
      :amount => amount,
      :charge_id => charge.id,
      :card_token => charge.source.id
    )
    
    flash[:notice] = 'Your payment was successful'
    redirect_to dashboard_path
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_payment_path
  end
end
