Rails.application.routes.draw do

  devise_for :users,
             path: '',
             path_names: {
                 sign_in: 'login',
                 sign_out: 'logout',
                 registration: 'signup'
             },
             controllers: {
                 sessions: 'sessions',
                 registrations: 'registrations',
                 passwords: 'passwords'
             }
  get '/account', to: 'accounts#show'
  post '/account', to: 'accounts#create'
  delete '/account', to: 'accounts#destroy'
  patch '/account', to: 'accounts#update'
  put '/account', to: 'accounts#update'

  scope '/api/v1' do
    resources :requests, path: :request
    get '/activate/:id', to: 'requests#activate'
    get '/request-own', to: 'requests#list'
    resources :responses, path: :response
    resources :fulfillments, path: :fulfillment
    resources :messages, path: :message
    resources :message_dispatches, path: :inbox
    get '/outbox', to: 'messages#index'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
