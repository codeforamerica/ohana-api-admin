Hsa::Application.routes.draw do

  devise_for :users

  root :to => "hsa#index"
  match '*id/edit_services' => 'hsa#edit_services'
  match 'edit_services' => 'hsa#edit_services'
  get "*id/" => "hsa#show"
end
