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
                 registrations: 'registrations'
             }

  scope '/api/v1' do
    resources :requests, path: :request
    resources :responses, path: :response
    resources :fulfillments, path: :fulfillment
    resources :messages, path: :message
    resources :message_dispatches, path: :inbox
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
