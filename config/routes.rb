Hsa::Application.routes.draw do

  devise_for :users

  root :to => "hsa#index"
  get "/locations" => "hsa#index"
  get "/locations/new" => "hsa#new"
  post "/locations/create_location" => "hsa#create_location"
  post '*id/edit_location' => 'hsa#edit_location'
  post 'edit_location' => 'hsa#edit_location'
  delete 'delete_location' => 'hsa#delete_location'
  get "confirm_delete_location" => 'hsa#confirm_delete_location', :as => :confirm_delete_location
  get "*id/" => "hsa#show", :as => "location"
end
