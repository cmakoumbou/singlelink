class UsersController < ApplicationController

  before_filter :authenticate_user!

  def edit_account
    @user = current_user
  end

  def update_account
    @user = User.find(current_user.id)
    if @user.update_with_password(user_account_params)
      if @user.subscriptions.present?
        cu = Stripe::Customer.retrieve(@user.subscriptions.take.customer_id)
        stripe_email = cu.email
        if stripe_email != @user.email
          cu.email = @user.email
          cu.save
        end
      end
      redirect_to root_path, notice: 'Account was successfully updated.'
    else
      render "edit_account"
    end
  end

  def edit_password
    @user = current_user
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update_with_password(user_params)
      sign_in @user, :bypass => true
      redirect_to root_path, notice: 'Password was successfully updated.'
    else
      render "edit_password"
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end

  def user_account_params
    params.require(:user).permit(:username, :email, :current_password)
  end
end

