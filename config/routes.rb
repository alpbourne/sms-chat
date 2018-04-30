Rails.application.routes.draw do
  resources :friends
  devise_for :users
  root to: 'pages#home'

end
