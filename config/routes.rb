FoodGenome::Application.routes.draw do
  resources :food, only: [ :index, :new, :create ]

  get  '/login',  to: 'sessions#new'
  post '/login',  to: 'sessions#create'
  get  '/logout', to: 'sessions#destroy'

  root to: redirect('/food')
end
