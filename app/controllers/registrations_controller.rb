class RegistrationsController < Devise::RegistrationsController
	prepend_before_filter :authenticate_scope!, :only => [:update, :delete, :destroy]

	def update
		@user = current_user

    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated

    	if @user.subscriptions.present?
    		cu = Stripe::Customer.retrieve(@user.subscriptions.take.customer_id)
    		stripe_email = cu.email
    		if stripe_email != @user.email
    			cu.email = @user.email
    			cu.save
    		end
    	end

      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

	def delete
	end
	
  def destroy
  	self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

  	@user = current_user
    @user_subscription = @user.subscriptions.take

    if resource.destroy_with_password(params[:user][:current_password])
    	UserMailer.cancel_subscription(@user).deliver
    	if @user_subscription.present?
       	cu = Stripe::Customer.retrieve(@user_subscription.customer_id)
				cu.delete
    	end
	    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)  
	    set_flash_message :notice, :destroyed if is_flashing_format?  
	    yield resource if block_given?  
	    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) } 
	  else
	  	render :delete
	  end 
  end

  protected

  def after_sign_up_path_for(resource)
    '/subscriptions'
  end
end