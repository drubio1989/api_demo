Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :articles do
    resources :comments, only: [:index, :create]
  end
  post 'sign_up', to: 'registrations#create'
  post 'login', to: 'access_tokens#create'
  delete 'logout', to: 'access_tokens#destroy'
end
