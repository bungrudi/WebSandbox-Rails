Rails.application.routes.draw do
  get 'store/items'
  get 'store/cart', to: 'store#cart'
  get 'store/cart/add', to: 'store#cart_add'
  post 'store/cart/update', to: 'store#cart_update'
  get 'reset_session', to: 'store#res_s'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
