Amped::Application.routes.draw do
  resources :comments
  resources :likes
  resources :purchases
  resources :products
  resources :users
  resources :user_sessions
  resources :password_reset, controller: 'PasswordResets'
  root to: "products#index"
  
  match 'login' => "user_sessions#new"
  match 'logout' => "user_sessions#destroy"
end
