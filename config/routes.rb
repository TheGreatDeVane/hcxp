Khcpl::Application.routes.draw do
  resources :venues do
    get :autocomplete, on: :collection
  end

  resources :bands do
    get :autocomplete, on: :collection
  end

  devise_for :users, controllers: {
    sessions: "sessions"
  }

  resources :users do
    get :saves, on: :member
    get :events, on: :member
  end

  resources :events do
    get :autocomplete, on: :collection

    resources :saves do
      post :toggle, on: :collection
    end

    get :bands, on: :member
    get :links, on: :member
    get :resources, on: :member
  end

  # Archived events
  scope '(:archive_prefix)', archive_prefix: /archive/ do
    root 'events#index', as: 'archive_root'
    resources :events
  end

  resources :search do
    get 'bands', on: :collection
  end

  get 'style_guide' => 'application#style_guide'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'events#index'

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
