Hsa::Application.routes.draw do

  root :to => "hsa#index"
  match 'edit_services' => 'hsa#edit_services'
  match "/:id" => "hsa#show"
end
