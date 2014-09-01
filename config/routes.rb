Khcpl::Application.routes.draw do
  Khcpl::Application.routes.default_url_options[:host] = Rails.application.config.action_mailer.default_url_options[:host]

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

  get 'style_guide' => 'application#style_guide'

  namespace :api, :defaults => { :format => 'json' } do
    namespace :v1 do
      resources :events do
        get :similar_by, on: :collection
        post :toggle_promote, on: :member
        post :toggle_save, on: :member
        get :event_bands, on: :member
      end

      resources :venues do
        post :tba, on: :collection
      end

      resources :bands

      resources :users do
        get :current, on: :collection
        get :locations, on: :collection
        post 'locations' => 'users#locations_create', on: :collection
        delete 'locations' => 'users#locations_destroy', on: :collection

        get :recent_venues, on: :collection
      end

      resources :search do
        get :venues, on: :collection
        get :bands, on: :collection
      end
    end
  end

  root 'events#index'

  resources :events, path: '/' do
    get :edit, on: :member
    # get :autocomplete, on: :collection

    get :browse, on: :collection

    resources :saves do
      post :toggle, on: :collection
    end

    get ':slug' => 'events#show', on: :member, as: :slugged
  end
end
