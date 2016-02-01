Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/mabika', as: 'rails_admin'
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

  post '/subscriptions' => 'subscriptions#pro_new', as: :pro_new_subscription

  # Renew / Cancel / Resume Subscriptions

  get '/subscriptions/renew' => 'subscriptions#renew', as: :renew_subscription
  post '/subscriptions/renew' => 'subscriptions#renew_confirm', as: :renew_confirm

  get '/subscriptions/cancel' => 'subscriptions#cancel', as: :cancel_subscription
  get '/subscriptions/resume' => 'subscriptions#resume', as: :resume_subscription

  get '/subscriptions/cancel/confirm' => 'subscriptions#cancel_confirm', as: :cancel_confirm
  get '/subscriptions/resume/confirm' => 'subscriptions#resume_confirm', as: :resume_confirm

  # Card Update

  get '/subscriptions/card' => 'subscriptions#card', as: :card_subscription
  post '/subscriptions/card' => 'subscriptions#card_update', as: :card_update

  mount StripeEvent::Engine, at: '/webhooks'

  devise_for :users, :path => '', :controllers => { :registrations => 'registrations' }
  as :user do
    get '/settings' => 'devise/registrations#edit'
    get '/settings/cancel' => 'registrations#delete'
  end 
  
  get '/:id' => 'links#profile', :as => :profile
end
