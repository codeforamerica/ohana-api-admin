Hsa::Application.routes.draw do

  devise_for :users

  root :to => "home#index"
  match "/locations" => "hsa#index"
  match "/locations/new" => "hsa#new"
  match "/locations/create_location" => "hsa#create_location"
  match '*id/edit_services' => 'hsa#edit_services'
  match 'edit_services' => 'hsa#edit_services'
  get "*id/" => "hsa#show"
end
