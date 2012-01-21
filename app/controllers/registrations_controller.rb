class RegistrationsController < Devise::RegistrationsController
  # Overwrite Devise's RegistrationController's update method to allow
  # users to edit their account without providing a password
  # Based on: https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-edit-their-account-without-providing-a-password
  def update
    logger.debug "Using own RegistrationsController"
    
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    
    any_password = [:password, :password_confirmation, :current_password].any? do |field|
      params[resource_name][field].present?
    end
    update_method = any_password ? :update_with_password : :update_without_password

    if resource.send(update_method, params[resource_name])
      set_flash_message :notice, :updated if is_navigational_format?
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => after_update_path_for(resource)
    else
      clean_up_passwords(resource)
      respond_with_navigational(resource){ render_with_scope :edit }
    end 
  end 
end