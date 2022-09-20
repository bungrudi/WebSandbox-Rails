Rails.application.routes.draw do
  get 'store/items'
  get 'store/cart', to: 'store#cart'
  get 'store/cart/add', to: 'store#cart_add'
  post 'store/cart/update', to: 'store#cart_update'
  post 'store/checkout/shipping', to: 'store#checkout_shipping'
  post 'store/checkout/billing', to: 'store#checkout_billing'
  post 'login', to: 'user#login'
  get 'logout', to: 'user#logout'
  get 'reset_session', to: 'store#res_s'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
