Spree::Core::Engine.routes.draw do
  
  match 'product_customizations/price', to: 'product_customizations#price', via: [:get, :post]
  match 'customize/:product_id', to: 'products#customize', as: 'customize', via: [:get, :post]

end
