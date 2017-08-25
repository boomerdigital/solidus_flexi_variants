Spree::Core::Engine.routes.draw do
  match 'product_customizations/price', to: 'product_customizations#price', via: [:get, :post]

  match 'customize/:product_id', to: 'products#customize', as: 'customize', via: [:get, :post]

  namespace :admin do
    resources :product_customization_types, only: [:index, :new, :create, :edit, :update, :destroy]

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

  match 'admin/variant_configurations/:variant_id', to: 'admin/variant_configurations#configure', via: [:get, :post]
end
