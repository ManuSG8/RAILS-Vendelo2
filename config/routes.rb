Rails.application.routes.draw do
  # ESTO DEBE ESTAR ARRIBA DE TODO, PARA DARLE PRIORIDAD
  namespace :authentication, path: '', as: '' do # Con 'path' vacio no tenemos que poner 'authentication' en la url, y con 'as' vacio no tenemos que poner 'authentication_users_new' sino 'users_new'
    resources :users, only: [:new, :create], path: '/register', path_names: { new: '/' }
    resources :sessions, only: [:new, :create, :destroy], path: '/login', path_names: { new: '/' }
  end

  resources :favorites, only: [:index, :create, :destroy], param: :product_id

  resources :users, only: :show, path: '/user', param: :username

  resources :categories, except: :show # Quitamos la opcion show
  
  # delete '/products/:id', to: 'products#destroy'
  # post '/products', to: 'products#create'
  # patch '/products/:id', to: 'products#update'
  # get '/products/new', to: 'products#new', as: :new_product
  # get '/products/:id/edit', to: 'products#edit', as: :edit_product
  # get '/products', to: 'products#index'
  # get '/products/:id', to: 'products#show', as: :product
  resources :products, path: '/' # Con esto podemos obviar las lineas anteriores al usar la convencion de nombres por defecto de rails, 
                                 # y con path: '/' hacemos que /products resida en /
end
