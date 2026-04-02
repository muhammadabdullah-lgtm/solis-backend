Rails.application.routes.draw do
  devise_for :users,
             path: 'api/v1/auth',
             path_names: {
               sign_in:      'sign_in',
               sign_out:     'sign_out',
               registration: 'sign_up'
             },
             controllers: {
               sessions:      'api/v1/auth/sessions',
               registrations: 'api/v1/auth/registrations'
             }

  namespace :api do
    namespace :v1 do
            resources :products, only: [:index, :show] do
        resources :reviews, only: [:index, :create, :update, :destroy]
      end
      resources :categories, only: [:index]
      resources :brands, only: [:index]

      resource :cart, only: [:show, :destroy] do
        resources :items, only: [:create, :update, :destroy], controller: 'cart_items'
      end

      resources :orders, only: [:index, :show, :create] do
        member do
          patch :cancel
        end
      end

      namespace :admin do
        resources :categories
        resources :brands
        resources :products
        resources :orders,  only: [:index, :show, :update]
        resources :reviews, only: [:index, :destroy]
      end
    end
  end
end