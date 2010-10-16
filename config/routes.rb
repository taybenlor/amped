Amped::Application.routes.draw do
  resources :follows
  resources :comments
  resources :likes
  resources :purchases
  resources :user_sessions
  resources :product_previews
  resource  :password_reset
  resources :user_sessions
  
  resources :products do
    member do
      get :download
      get :fetch_preview
      get :related
    end
    collection do
      get :search
    end
  end
  
  resources :users do
    member do
      get :widget
    end
  end
  
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
  
  match 'login' => "user_sessions#new"
  match 'logout' => "user_sessions#destroy"
end
