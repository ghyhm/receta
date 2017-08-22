Rails.application.routes.draw do
  root 'home#index'

  resources :recipes, only: %i[index show create update destroy]
end
