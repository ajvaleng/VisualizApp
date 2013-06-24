RailsAdmin.config do |config|

  config.current_user_method { current_user } #auto-generated
  config.included_models = ["Recoleccion","DataFile","User"]
  config.authorize_with :cancan
end