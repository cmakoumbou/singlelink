Rails.application.routes.draw do

  authenticated :user do
    root to: 'links#index', as: :authenticated_root
  end

  devise_scope :user do
    # root to: "devise/registrations#new"
    root to: "static_pages#home"
  end

  get '/help' => 'static_pages#help', as: :help

  get '/about' => 'static_pages#about', as: :about
  get '/terms' => 'static_pages#terms', as: :terms
  get '/privacy' => 'static_pages#privacy', as: :privacy
  get '/contact' => 'static_pages#contact', as: :contact

  get '/features' => 'static_pages#features', as: :features
  get '/pricing' => 'static_pages#pricing', as: :pricing

  resources :links, except: [:show] do
    member do
      put :move_up
      put :move_down
      post :enable
      post :disable
    end
  end

  resources :subscriptions, only: [:index]

  post '/subscriptions' => 'subscriptions#pro', as: :pro_subscription
  post '/subscriptions/renew' => 'subscriptions#renew', as: :renew_subscription
  post '/subscriptions/card' => 'subscriptions#card', as: :card_subscription
  get '/subscriptions/cancel' => 'subscriptions#cancel', as: :cancel_subscription
  get '/subscriptions/resume' => 'subscriptions#resume', as: :resume_subscription

  mount StripeEvent::Engine, at: '/webhooks'

  devise_for :users, :path => '', :controllers => { :registrations => 'registrations' }, :path_names => {:sign_in => 'login', :sign_out => 'logout', :sign_up => 'signup'}
  as :user do
    get '/settings' => 'devise/registrations#edit'
    get '/settings/cancel' => 'registrations#delete'
  end 

  get '/settings/password' => 'users#edit_password', as: :edit_password
  patch '/settings/update_password' => 'users#update_password', as: :update_password

  get '/settings/account' => 'users#edit_account', as: :edit_account
  patch '/settings/update_account' => 'users#update_account', as: :update_account
  
  get '/:id' => 'links#profile', :as => :profile

  mount RailsAdmin::Engine => '/admin/mabika', as: 'rails_admin'
end
