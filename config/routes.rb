Hsa::Application.routes.draw do

  devise_for :users

  root :to => "hsa#index"
  match 'edit_services' => 'hsa#edit_services'
  match "/:id" => "hsa#show"
end
