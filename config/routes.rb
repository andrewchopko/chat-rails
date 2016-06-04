Rails.application.routes.draw do
  devise_for :users
  resources :chats do
    resources :messages
  end

  root "chats#index"
end
