Rails.application.routes.draw do
  get 'staticpage/home'

  devise_for :users, :controllers => {registrations: 'registrations'}
  resources :chats do
    resources :messages
  end

  root "chats#index"
end
