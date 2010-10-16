Amped::Application.routes.draw do
  resources :follows

  resources :comments
  resources :likes
  resources :purchases
  resources :products do
    member do
      get :download
      get :fetch_preview
    end
  end
  resources :users
  resources :user_sessions
  resources :product_previews

  resource :password_reset

  resources :cart do
    collection do
      get :checkout
      get :clear
      get :confirm
      get :complete
      post :complete      
    end    
  end

  root to: "products#index"
  
  resources :user_sessions
  
  resource :password_reset
  
  match 'login' => "user_sessions#new"
  match 'logout' => "user_sessions#destroy"
end
