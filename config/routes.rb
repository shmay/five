Five::Application.routes.draw do
  resources :events

  resources :locations

  resources :groups do
    member do
      post 'join'
    end
  end

  resources :playings

  resources :games

  devise_for :users

  namespace :admin do
    resources :accounts
    resources :videos do
      member do
        post 'change_category'
      end
    end
    resources :categories
    resources :users
    resources :questions

    root to: 'accounts#index'
  end

  get 'profiles/:id' => 'users#show', as: :profile
  get 'users' => 'users#index', as: :users
  put 'users/:id' => 'users#update', as: :update_user
  post 'users/:id/invite' => 'users#invite', as: :invite_user

  delete 'invites/:id' => 'invites#destroy', as: :destroy_invite

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  # Static/info pages
  match '/about' => 'home#about', via: :get, as: :about
  match '/contact' => 'home#contact', via: :get, as: :contact


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
