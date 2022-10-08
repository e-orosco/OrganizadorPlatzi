class ApplicationController < ActionController::Base
  before_action :set_locale 

  before_action :authenticate_user! 

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path
  end     

  def set_locale
      I18n.locale = 'es'
  end 
  
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
