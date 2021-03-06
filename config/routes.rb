Visualizapp::Application.routes.draw do
  
  resources :data_files


  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :recorridos
  match '/buses', :to => 'recorridos#get_buses', :as => :buses

  resources :operators

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users, :path_prefix => 'my'
  resources :users
  
  match "recoleccions" => "recoleccions#create"
end