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

  # Pro / Business Subscriptions

  get '/subscriptions/pro' => 'subscriptions#pro', as: :pro_subscription
  post '/subscriptions/pro' => 'subscriptions#pro_confirm', as: :pro_confirm

  # Cancel / Resume Subscriptions

  get '/subscriptions/cancel' => 'subscriptions#cancel', as: :cancel_subscription
  get '/subscriptions/resume' => 'subscriptions#resume', as: :resume_subscription

  post '/subscriptions/cancel' => 'subscriptions#cancel_confirm', as: :cancel_confirm
  post '/subscriptions/resume' => 'subscriptions#resume_confirm', as: :resume_confirm

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
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
