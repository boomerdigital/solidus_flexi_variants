Spree::Core::Engine.routes.draw do
  match 'product_customizations/price', to: 'product_customizations#price', via: [:get, :post]

  match 'customize/:product_id', to: 'products#customize', as: 'customize', via: [:get, :post]

  namespace :admin do

    resources :product_customization_types do
      resources :customizable_product_options do
        member do
          get :select
          post :select
          get :remove
        end
        collection do
          get :available
          get :selected
        end
      end
    end

    resources :product_customization_types

    delete '/ad_hoc_option_values/:id', to: "ad_hoc_option_values#destroy", as: :ad_hoc_option_value

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

      resources :product_customization_types do
        member do
          get :select
          post :select
          get :remove
        end
        collection do
          get :available
          get :selected
        end
      end
    end #products
  end # namespace :admin

  match 'admin/variant_configurations/:variant_id', to: 'admin/variant_configurations#configure', via: [:get, :post]
end
