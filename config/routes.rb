Khcpl::Application.routes.draw do
  resources :venues do
    get :autocomplete, on: :collection
  end

  resources :bands do
    get :autocomplete, on: :collection
  end

  devise_for :users, controllers: {
    sessions: 'sessions'
  }

  resources :users do
    get :saves, on: :member
    get :events, on: :member
  end

  resources :search do
    get 'bands', on: :collection
  end

  get 'style_guide' => 'application#style_guide'

  namespace :api do
    namespace :v1 do
      resources :events do
        get :similar_by, on: :collection
      end

      resources :users do
        get :locations, on: :collection
        post 'locations' => 'users#locations_create', on: :collection
        delete 'locations' => 'users#locations_destroy', on: :collection
      end
    end
  end

  root 'events#index'

  resources :events, path: '/' do
    get :edit, on: :member
    get :autocomplete, on: :collection

    resources :saves do
      post :toggle, on: :collection
    end

    get :bands, on: :member
    get :links, on: :member
    get :resources, on: :member

    get ':slug' => 'events#show', on: :member, as: :slugged
  end
end
