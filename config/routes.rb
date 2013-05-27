FoodGenome::Application.routes.draw do
  resources :food, only: [ :index, :new, :create ]
  root to: redirect('/food')
end
