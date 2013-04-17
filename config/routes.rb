Transition::Application.routes.draw do
  resources :organisations do
  	resources :sites
  end

  resources :sites do
  	resources :hosts
  end

  resources :hosts,
    :constraints => { :id => /[^\/]+(?=\.html\z|\.json\z)|[^\/]+/ }

  root :to => 'dashboard#index'
end
