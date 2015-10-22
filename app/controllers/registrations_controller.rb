class RegistrationsController < Devise::RegistrationsController
	prepend_before_filter :authenticate_scope!, :only => [:delete, :destroy]

	def delete
	end
	
  def destroy
  	self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    # if current_user.valid_password?(params[:current_password])
    if resource.destroy_with_password(params[:user][:current_password])
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
    '/pricing'
  end 
end