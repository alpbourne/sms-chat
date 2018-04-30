Rails.application.routes.draw do
  namespace :chats do
  get 'messages/index'
  end

  get 'chats/index'

  resources :friends
  devise_for :users
  root to: 'pages#home'

    resources :chats, only: [:index] do
      resources :messages, module: :chats, only: [:index, :create]
    end

  post 'chats/messages/reply', to: 'chats/messages#reply'

end
