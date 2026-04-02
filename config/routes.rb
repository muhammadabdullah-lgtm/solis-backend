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
            resources :products, only: [:index, :show]
      resources :categories, only: [:index]
      resources :brands, only: [:index]
      namespace :admin do

        resources :categories
        resources :brands
        resources :products
      end
    end
  end
end