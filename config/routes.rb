Amped::Application.routes.draw do
  resources :comments
  resources :likes
  resources :purchases
  resources :products
  resources :users
  root :to => "products#index"
  
  match 'login' => "user_sessions#new"
  match 'logout' => "user_sessions#destroy"
end
