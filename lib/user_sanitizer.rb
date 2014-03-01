class User::ParameterSanitizer < Devise::ParameterSanitizer
  private
  def account_update
    default_params.permit(:email, :encrypted_password, :role, :name)
  end
end