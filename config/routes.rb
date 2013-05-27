FoodGenome::Application.routes.draw do
  resources :food, only: [ :index, :new, :create ]
  root to: redirect('/food')

  match '/food/new', :to => 'food#new'
end
