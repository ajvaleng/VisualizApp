class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    puts exception.message
    redirect_to '/', :alert => exception.message
  end

  # def current_ability
  #   @current_ability ||= Ability.new(current_admin_user)
  # end
end
