class RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :authenticate_scope!, :only => [:delete]

  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        # set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
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


  def after_update_path_for(resource)
    profile_path(resource)
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end