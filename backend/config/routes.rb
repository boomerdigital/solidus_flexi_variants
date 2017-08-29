Spree::Core::Engine.routes.draw do

  namespace :admin do
    resources :product_customization_types, only: [:index, :new, :create, :edit, :update, :destroy]

    resources :variant_configurations, only: [:show, :create]

    resources :products do

      resources :ad_hoc_option_types, except: [:show] do
        member do
          get :add_option_value
          get :select
          post :select
        end

        resources :ad_hoc_option_values, only: [:destroy] do
          collection do
            post :update_positions
          end
        end
      end

      resources :ad_hoc_variant_exclusions, except: [:edit, :update]

      resources :product_customization_types, except: [:index] do
        member do
          get :select
          post :select
          get :remove
        end

        collection do
          get :selected
          get :available
        end
      end
    end #products
    
  end # namespace :admin
  
end
